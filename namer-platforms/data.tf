# Read remote state of existing region to get outputs (namelye endpoint and cert)
data "terraform_remote_state" "ceratf_regional" {
  backend = "s3"

  config = {
    bucket = "fe-cluster-tf-state"
    region = "us-west-2"
    key    = "fe-eks-cluster/REPLACEME-sub-domain/terraform.tfstate"
  }
}

# Read the remote state of the ceratf-deployment-global plan to get its outputs
data "terraform_remote_state" "ceratf_deployment_global" {
  backend = "s3"

  config = {
    bucket = "fe-cluster-tf-state"
    region = "us-west-2"
    key    = "fe-eks-cluster/global/terraform.tfstate"
  }
}

data "aws_region" "current" {}
data "kubernetes_secret" "vault_token" {
  metadata {
    name      = "vault-token"
    namespace = data.terraform_remote_state.ceratf_regional.outputs.vault_namespace
  }
}