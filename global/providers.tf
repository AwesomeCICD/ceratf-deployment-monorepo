provider "aws" {
  default_tags {
    tags =  var.common_tags
  }
}


terraform {
  backend "s3" {
    bucket         = "fe-cluster-tf"
    region         = "us-west-2"
    key            = "fe-eks-cluster/global/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}