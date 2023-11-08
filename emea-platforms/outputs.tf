
output "circleci_region" {
  value = local.circleci_region
}

/*
#For Kubernetes custom resources
output "cluster_endpoint" {
  value = module.se_eks_cluster.cluster_endpoint
}

output "cluster_name" {
  value = module.se_eks_cluster.cluster_name
}

output "cluster_ca_certificate" {
  value = module.se_eks_cluster.cluster_ca_certificate
}



output "target_domain" {
  value = module.regional_dns.r53_subdomain_zone_name
}
output "r53_subdomain_zone_id" {
  value = module.regional_dns.r53_subdomain_zone_id
}
output "istio_namespace" {
  value = module.helm_istio.istio_namespace
}
*/