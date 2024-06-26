# Putting this here for visibility
locals {
  circleci_region = "japac"
  common_namespace_labels = {
    istio-injection = "enabled"
  }
}

module "se_eks_cluster" {
  source = "git@github.com:AwesomeCICD/ceratf-module-eks.git?ref=0.0.3"

  cluster_version                 = "1.27"
  cluster_suffix                  = local.circleci_region
  node_instance_types             = ["m5.xlarge"]
  nodegroup_desired_capacity      = "2"
  eks_access_iam_role_name        = data.terraform_remote_state.ceratf_deployment_global.outputs.eks_access_iam_role_name
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
}

module "regional_dns" {
  source = "git@github.com:AwesomeCICD/ceratf-module-dns.git?ref=0.0.1"

  root_zone_name  = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_name
  root_zone_id    = data.terraform_remote_state.ceratf_deployment_global.outputs.r53_root_zone_id
  circleci_region = local.circleci_region
}


# A bit odd to see istio here, but it includes cert-manager whcih interacts with KMS and Istio creates ELBs 
# that will prevent this plan from destorying cluster (AWS blocks delete since networkinterface is attached)
module "helm_istio" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-istio.git?ref=1.4.2"

  aws_region                = data.aws_region.current.name
  aws_account_no            = data.aws_caller_identity.current.account_id
  namespace_labels          = local.common_namespace_labels
  cluster_security_group_id = module.se_eks_cluster.cluster_security_group_id
  node_security_group_id    = module.se_eks_cluster.node_security_group_id
  circleci_region           = local.circleci_region
  target_domain             = module.regional_dns.r53_subdomain_zone_name
  r53_subdomain_zone_id     = module.regional_dns.r53_subdomain_zone_id
  cluster_oidc_provider_arn = module.se_eks_cluster.oidc_provider_arn
  depends_on                = [module.se_eks_cluster]
  #global_oidc_provider_arn  = data.terraform_remote_state.ceratf_deployment_global.outputs.oidc_provider_arn
}


module "vault" {
  source = "git@github.com:AwesomeCICD/ceratf-module-helm-vault?ref=1.0.4"

  circleci_region           = local.circleci_region
  namespace                 = "vault"
  cluster_name              = module.se_eks_cluster.cluster_name
  cluster_oidc_provider_arn = module.se_eks_cluster.oidc_provider_arn

  depends_on = [module.se_eks_cluster, module.helm_istio, module.regional_dns]
}
