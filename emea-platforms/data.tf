# Read remote state of existing region to get outputs (namelye endpoint and cert)
data "terraform_remote_state" "ceratf_regional" {
  backend = "s3"

  config = {
    bucket = "se-cluster-tf-state"
    region = "us-west-2"
    key    = "fe-eks-cluster/emea/terraform.tfstate"
  }
}

data "kubernetes_secret" "vault_token" {
  metadata {
    name      = "vault-token"
    namespace = data.terraform_remote_state.ceratf_regional.outputs.vault_namespace
  }
}