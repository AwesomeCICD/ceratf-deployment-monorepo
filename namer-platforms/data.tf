# Read remote state of existing region to get outputs (namelye endpoint and cert)
data "terraform_remote_state" "ceratf_regional" {
  backend = "s3"

  config = {
    bucket = "fe-cluster-tf-state"
    region = "us-west-2"
    key    = "fe-eks-cluster/xxxxx/terraform.tfstate"
  }
}

data "aws_region" "current" {}
data "kubernetes_secret" "vault_token" {
  metadata {
    name      = "vault-token"
    namespace = data.terraform_remote_state.ceratf_regional.outputs.vault_namespace
  }
}