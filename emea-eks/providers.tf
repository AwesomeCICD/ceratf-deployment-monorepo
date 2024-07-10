provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      critical-resource = "critical-until-2024-02-01"
      owner             = "solutions@circleci.com"
      purpose           = "CERA is a customer facing demo architecture used by Field Engineering team."
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "fe-cluster-tf-state"
    region         = "us-east-1"
    key            = "fe-eks-cluster/emea/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}

# The k8s and helm configs are duplicated which is not ideal
# Not sure whether there's a way for helm to inherit from the k8s provider so we don't have to get two separate tokens
provider "kubernetes" {
  host                   = module.fe_eks_cluster.cluster_endpoint
  cluster_ca_certificate = module.fe_eks_cluster.cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.fe_eks_cluster.cluster_name]
    command     = "aws"
  }
}

# For k8s custom resources deployed with kubectl_manifest (because kubernetes_manifest does not work well with CRDs)
provider "kubectl" {
  host                   = module.fe_eks_cluster.cluster_endpoint
  cluster_ca_certificate = module.fe_eks_cluster.cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.fe_eks_cluster.cluster_name]
    command     = "aws"
  }
  load_config_file = false
}

provider "helm" {
  kubernetes {
    host                   = module.fe_eks_cluster.cluster_endpoint
    cluster_ca_certificate = module.fe_eks_cluster.cluster_ca_certificate
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.fe_eks_cluster.cluster_name]
      command     = "aws"
    }
  }
}