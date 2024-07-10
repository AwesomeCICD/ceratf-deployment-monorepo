variable "circleci_org_id" {
  description = "CircleCI org ID whose jobs will be authenticating via OIDC."
}

variable "ddb_state_locking_table_name" {
  description = "Name of DynamoDB table used for state locking."
}

#Can't be retrieved via data source, but unlikely to change.
variable "se_sso_iam_role" {
  description = "Name of AWS IAM SSO role to be used for EKS auth by SE team."
  #default     = "AWSReservedSSO_LimitedAdmin_bfe1dfbf15bdb9c9"
  default = "cera_infra"
}

variable "fe_email_usernames" {
  description = "List of FE team members' email usernames."
}

variable "common_tags" {
  description = "Tags to be applied to all resources."
  type        = map(string)
  default = {
    "cost_center"    = "mixed"
    "owner"          = "field@circleci.com"
    "team"           = "Field Engineering"
    "iac"            = "true"
    "opt_in"         = "true"
    "critical_until" = "critical-until-2024-07-31"
    "purpose"        = "CERA is a customer facing demo architecture used by Field Engineering team."
  }
}

# variable "kuma_admin_password" {
#   sensitive   = true
#   description = "Set TF_VAR_kuma_admin_password in root module execution."
# }