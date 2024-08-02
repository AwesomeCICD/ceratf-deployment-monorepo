variable "circleci_org_id" {
  description = "CircleCI org ID whose jobs will be authenticating via OIDC."
}

variable "ddb_state_locking_table_name" {
  description = "Name of DynamoDB table used for state locking."
}
variable "fe_pipeline_iam_prefix" {
  description = "Name of role and policy prefix to create for use by pipeline and cluster"
  #default     = "AWSReservedSSO_LimitedAdmin_bfe1dfbf15bdb9c9"
}
variable "fe_operator_iam_prefix" {
  description = "Name of role and policy prefix to create for use by ops team"
  #default     = "AWSReservedSSO_LimitedAdmin_bfe1dfbf15bdb9c9"
}

#Can't be retrieved via data source, but unlikely to change. Provided by company SSO integreaion, visible in IAM console for your user.
variable "fe_sso_iam_role" {
  description = "Name of AWS IAM SSO role to be used for EKS auth by SE team."
  #default     = "AWSReservedSSO_LimitedAdmin_bfe1dfbf15bdb9c9"
  default = "" # empty is no SSO, use direct IAM usernames
}
# emails with SSO login rights under assumed role above.
variable "fe_email_usernames" {
  description = "List of FE team members' email usernames."
}
# OR NON-SSO
# Just list created IAM usernames
variable "fe_iam_usernames" {
  description = "List of externally created/manual IAM usernames."
}



variable "common_tags" {
  description = "Tags to be applied to all resources."
  type        = map(string)
  default = {
    "cost_center"         = "sm"
    "owner"               = "field@circleci.com"
    "Team"                = "Field Engineering"
    "iac"                 = "true"
    "optimization_opt_in" = "true"
    "critical_until"      = "2024-12-31"
    "data_classification" = "low"
    "purpose"             = "CERA is a customer facing demo architecture used by Field Engineering team."
  }
}

variable "root_domain_name" {
  type = string
}

variable "aux_domain_name" {
  type = string
  description = "Can be used for migrations or alternate domains access."
}

variable "break_the_glass" {
  type        = bool
  description = "Allows FE team to assume FULL RIGHTS OF PIPLEINE ROLE"
  default     = false
}


# variable "kuma_admin_password" {
#   sensitive   = true
#   description = "Set TF_VAR_kuma_admin_password in root module execution."
# }