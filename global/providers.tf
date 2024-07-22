provider "aws" {
  default_tags {
    tags = var.common_tags
  }
  region = "us-west-2"
}


terraform {
  backend "s3" {
    #profile        = "jennings-dev-ccidev"
    bucket         = "fe-cluster-tf-state"
    region         = "us-west-2"
    key            = "fe-eks-cluster/global/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}