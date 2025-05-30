# Putting this here for visibility
locals {
  common_namespace_labels = {
    istio-injection = "enabled"
  }
}


module "fe_eks_cluster" {
  source = "git@github.com:AwesomeCICD/ceratf-module-eks.git?ref=7.2.0"

  cluster_version                = "1.30"
  cluster_suffix                 = var.fe_domain_region
  node_instance_types            = ["m5a.xlarge"]
  nodegroup_desired_capacity     = 2
  cluster_endpoint_public_access = true
  default_fieldeng_tags          = data.terraform_remote_state.ceratf_deployment_global.outputs.common_tags
  # this should be replaced with a cluster_admin speciic role outide aws role used by pipeline.
  principal_arn = data.terraform_remote_state.ceratf_deployment_global.outputs.operator_access_iam_role_arn
  pipeline_arn  = data.terraform_remote_state.ceratf_deployment_global.outputs.pipeline_access_iam_role_arn
}


module "regional_dns" {
  source = "git@github.com:AwesomeCICD/ceratf-module-dns.git?ref=1.0.3"

  root_zone_name  = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_name
  root_zone_id    = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_id
  aux_zone_name   = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_aux_zone_name
  aux_zone_id     = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_aux_zone_id
  circleci_region = var.fe_domain_region
}


# A bit odd to see istio here, but it includes cert-manager whcih interacts with KMS and Istio creates ELBs 
# that will prevent this plan from destorying cluster (AWS blocks delete since networkinterface is attached)
module "helm_istio" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-istio.git?ref=10.1.0"

  aws_region                = data.aws_region.current.name
  aws_account_no            = data.aws_caller_identity.current.account_id
  namespace_labels          = local.common_namespace_labels
  cluster_security_group_id = module.fe_eks_cluster.cluster_security_group_id
  node_security_group_id    = module.fe_eks_cluster.node_security_group_id
  circleci_region           = var.fe_domain_region
  root_domain_zone_id       = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_id
  root_domain_zone_name     = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_name
  aux_domain_zone_id        = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_aux_zone_id
  aux_domain_zone_name      = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_aux_zone_name
  target_domain             = module.regional_dns.r53_subdomain_zone_name
  r53_subdomain_zone_id     = module.regional_dns.r53_subdomain_zone_id
  target_domain_aux         = module.regional_dns.r53_subdomain_zone_name_aux
  r53_subdomain_zone_id_aux = module.regional_dns.r53_subdomain_zone_id_aux
  cluster_oidc_provider_arn = module.fe_eks_cluster.oidc_provider_arn
  depends_on                = [module.fe_eks_cluster]
  #global_oidc_provider_arn  = data.terraform_remote_state.ceratf_deployment_global.outputs.oidc_provider_arn
}


module "vault" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-vault?ref=3.0.1"

  circleci_region           = var.fe_domain_region
  namespace                 = "vault"
  cluster_name              = module.fe_eks_cluster.cluster_name
  cluster_oidc_provider_arn = module.fe_eks_cluster.oidc_provider_arn
  root_domain               = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_name
  storage_az                = "${data.aws_region.current.name}a"

  depends_on = [module.fe_eks_cluster, module.helm_istio, module.regional_dns]
}
