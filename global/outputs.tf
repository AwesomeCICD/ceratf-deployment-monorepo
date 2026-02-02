### Created resource values ###
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.awesomeci.arn
}

### Variable values ###
output "circleci_org_id" {
  value = var.circleci_org_id
}

output "pipeline_access_iam_role_arn" {
  value = aws_iam_role.fe_eks.arn
}

output "pipeline_access_iam_role_name" {
  value = aws_iam_role.fe_eks.name
}

output "operator_access_iam_role_arn" {
  value = aws_iam_role.operator_access_role.arn
}

output "operator_access_iam_role_name" {
  value = aws_iam_role.operator_access_role.name
}

output "common_tags" {
  value = merge(
    var.common_tags,
    var.aws_partner_product_id != "" ? {
      "aws:partner:product" = var.aws_partner_product_id
    } : {}
  )
  sensitive = true
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

output "r53_aux_zone_name" {
  value = aws_route53_zone.aux_domain[0].name
}

output "r53_aux_zone_id" {
  value = aws_route53_zone.aux_domain[0].zone_id
}

#output "kuma_fqdn" {
# value = module.uptime_kuma.kuma_fqdn
#}

#output "kuma_admin_password" {
# value       = var.kuma_admin_password
#sensitive   = true
#description = "Expose to regional modules"
#}
