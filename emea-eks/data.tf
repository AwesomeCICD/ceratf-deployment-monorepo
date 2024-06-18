# Read the remote state of the ceratf-deployment-global plan to get its outputs
data "terraform_remote_state" "ceratf_deployment_global" {
  backend = "s3"

  config = {
    bucket = "se-cluster-tf-state"
    region = "us-west-2"
    key    = "se-eks-cluster/global/terraform.tfstate"
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}