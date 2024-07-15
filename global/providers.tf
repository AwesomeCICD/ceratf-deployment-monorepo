provider "aws" {
  default_tags {
    tags = var.common_tags
  }
}


terraform {
  backend "s3" {
    #profile        = "jennings-dev-ccidev"
    bucket         = "fe-tf-cluster-capitalone"
    region         = "us-east-1"
    key            = "fe-eks-cluster/global/terraform.tfstate"
    dynamodb_table = "cera-tf-lock"
  }
}