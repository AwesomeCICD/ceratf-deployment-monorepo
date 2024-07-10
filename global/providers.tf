provider "aws" {
  default_tags {
    tags = var.common_tags
  }
}


terraform {
  backend "s3" {
<<<<<<< HEAD
    #profile        = "jennings-dev-ccidev"
    bucket         = "fe-tf-cluster-capitalone"
    region         = "us-east-1"
    key            = "se-eks-cluster/global/terraform.tfstate"
=======
    bucket         = "fe-cluster-tf-state"
    region         = "us-west-2"
    key            = "fe-eks-cluster/global/terraform.tfstate"
>>>>>>> fe-account
    dynamodb_table = "cera-tf-lock"
  }
}