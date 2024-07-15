### Created resource values ###
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.awesomeci.arn
}

### Variable values ###
output "circleci_org_id" {
  value = var.circleci_org_id
}

output "eks_access_iam_role_arn" {
  value = aws_iam_role.fe_eks.arn
}

output "eks_access_iam_role_name" {
  value = aws_iam_role.fe_eks.name
}

output "common_tags" {
  value = var.common_tags
}

output "fe_email_usernames" {
  value = var.fe_email_usernames
}

output "r53_root_zone_name" {
  value = aws_route53_zone.demo_domain.name
}

output "r53_root_zone_id" {
  value = aws_route53_zone.demo_domain.zone_id
}

#output "kuma_fqdn" {
# value = module.uptime_kuma.kuma_fqdn
#}

#output "kuma_admin_password" {
# value       = var.kuma_admin_password
#sensitive   = true
#description = "Expose to regional modules"
#}
