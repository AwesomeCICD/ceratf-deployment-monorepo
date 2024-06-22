# Putting this here for visibility
locals {
  circleci_region = "namer"
  common_namespace_labels = {
    istio-injection = "enabled"
  }
}



module "vault_config" {
  source = "git@github.com:AwesomeCICD/ceratf-module-vault-config?ref=1.8.1"
}

module "nexus" {
  source               = "git@github.com:AwesomeCICD/ceratf-module-helm-nexus?ref=5.0.2"
  nexus_admin_password = var.nexus_admin_password
  circleci_region      = local.circleci_region
  target_domain        = data.terraform_remote_state.ceratf_regional.outputs.target_domain
  depends_on           = [module.vault_config]
}

module "nexus_config" {
  source     = "git@github.com:AwesomeCICD/ceratf-module-nexus-config?ref=rev-369"
  depends_on = [module.nexus]
}

module "app_spaces" {
  source           = "git@github.com:AwesomeCICD/ceratf-module-appspaces?ref=1.4.0"
  cluster_endpoint = data.terraform_remote_state.ceratf_regional.outputs.cluster_endpoint
  cluster_name     = data.terraform_remote_state.ceratf_regional.outputs.cluster_name
}


module "argo_rollouts" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-argorollouts?ref=1.0.1"
}



module "release_agent" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-cci-release-agent?ref=1.0.1"

  release_agent_token = var.rt_token

  managed_namespaces = ["default", "guidebook", "guidebook-dev", "boa", "boa-dev", "circleci-release-agent-system", "dr-demo", "eddies-demo"]

  depends_on = [module.argo_rollouts]
}
