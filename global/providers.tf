provider "aws" {
  default_tags {
    tags = {
      critical-resource = "critical-until-2024-02-01"
      owner             = "solutions@circleci.com"
      purpose           = "CERA is a customer facing demo architecture used by Solutions Engineering team."
    }
  }
}


terraform {
  backend "s3" {
    #profile        = "jennings-dev-ccidev"
    bucket         = "fe-tf-cluster-capitalone"
    region         = "us-east-1"
    key            = "se-eks-cluster/global/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}