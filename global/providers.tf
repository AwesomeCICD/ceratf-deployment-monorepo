provider "aws" {
  default_tags {
    tags = var.common_tags
  }
  region = var.fe_aws_region
}


terraform {
  backend "s3" {
    #profile        = "jennings-dev-ccidev"
    bucket         = "fe-cluster-tf-state"
    region         = var.fe_aws_region
    key            = "fe-eks-cluster/global/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}