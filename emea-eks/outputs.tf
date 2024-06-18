output "kubeconfig_update_command" {
  value = module.fe_eks_cluster.kubeconfig_update_command
}

output "circleci_region" {
  value = local.circleci_region
}

output "cluster_name" {
  value = module.fe_eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value     = module.fe_eks_cluster.cluster_endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.fe_eks_cluster.cluster_ca_certificate
  sensitive = true
}

output "target_domain" {
  value = module.regional_dns.r53_subdomain_zone_name
}

output "cluster_oidc_provider_arn" {
  value = module.fe_eks_cluster.oidc_provider_arn
}
output "vault_namespace" {
  value = module.vault.namespace
}

/*
#For Kubernetes custom resources
output "cluster_endpoint" {
  value = module.fe_eks_cluster.cluster_endpoint
}

output "cluster_name" {
  value = module.fe_eks_cluster.cluster_name
}

output "cluster_ca_certificate" {
  value = module.fe_eks_cluster.cluster_ca_certificate
}


output "r53_subdomain_zone_id" {
  value = module.regional_dns.r53_subdomain_zone_id
}
output "istio_namespace" {
  value = module.helm_istio.istio_namespace
}
*/