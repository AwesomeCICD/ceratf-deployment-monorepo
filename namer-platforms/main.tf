# Putting this here for visibility
locals {
  common_namespace_labels = {
    istio-injection = "enabled"
  }
}



module "vault_config" {
  source = "git@github.com:AwesomeCICD/ceratf-module-vault-config?ref=1.14.0"
}


module "nexus" {
  source               = "git@github.com:AwesomeCICD/ceratf-module-helm-nexus?ref=10.0.1"
  nexus_admin_password = var.nexus_admin_password
  circleci_region      = data.terraform_remote_state.ceratf_regional.outputs.circleci_region
  target_domain        = data.terraform_remote_state.ceratf_regional.outputs.target_domain
  depends_on           = [module.vault_config]
}

module "nexus_config" {
  source     = "git@github.com:AwesomeCICD/ceratf-module-nexus-config?ref=0.4.0"
  depends_on = [module.nexus]
}


module "app_spaces" {
  source           = "git@github.com:AwesomeCICD/ceratf-module-appspaces?ref=3.5.0"
  cluster_endpoint = data.terraform_remote_state.ceratf_regional.outputs.cluster_endpoint
  cluster_name     = data.terraform_remote_state.ceratf_regional.outputs.cluster_name
}


module "argo_rollouts" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-argorollouts?ref=1.0.1"
}



module "release_agent" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-cci-release-agent?ref=1.4.0"

  release_agent_token = var.rt_token

  managed_namespaces = ["default", "guidebook", "boa", "circleci-release-agent-system", "dr-demo", "eddies-demo", "training", "circle-shop"]

  depends_on = [module.argo_rollouts]
}


module "release_agent_dev" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-cci-release-agent?ref=1.4.0"

  release_agent_token = var.rt_token_dev

  managed_namespaces = ["guidebook-dev", "boa-dev", "dr-demo-dev", "training-dev", "circle-shop-dev"]

  environment_suffix = "-dev"

  depends_on = [module.argo_rollouts]
}


module "authentik" {
  count         = var.fe_domain_region == "namer" ? 1 : 0
  source        = "git@github.com:AwesomeCICD/ceratf-module-helm-authentik.git?ref=1.1.0"
  target_domain = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_name
}
