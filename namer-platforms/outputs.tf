
output "circleci_region" {
  value = data.terraform_remote_state.ceratf_regional.outputs.circleci_region
}

output "grafana_url" {
  value       = module.grafana.grafana_internal_url
  description = "Internal URL to access Grafana within the cluster"
}

output "grafana_ingress_hosts" {
  value       = module.grafana.grafana_ingress_hosts
  description = "Ingress hosts for external Grafana access"
}

###############################################################################
# CircleCI Usage PostgreSQL
###############################################################################

output "circleci_usage_pg_host" {
  description = "Internal cluster DNS for the CI/CD usage Postgres"
  value       = "circleci-usage-pg-postgresql.monitoring.svc.cluster.local"
}

output "circleci_usage_pg_port" {
  value = 5432
}

output "circleci_usage_pg_database" {
  value = "circleci_usage"
}

output "circleci_usage_pg_username" {
  value = "circleci"
}

output "circleci_usage_pg_password" {
  value     = random_password.circleci_usage_pg.result
  sensitive = true
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