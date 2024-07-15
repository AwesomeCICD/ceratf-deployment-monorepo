#-------------------------------------------------------------------------------
# ROUTE 53 RESOURCES
# Registering a domain creates a zone for us. 
# lookup that zone,  use import it, set our values to it
#-------------------------------------------------------------------------------

locals {
  root_domain_zone_id = var.r53_root_zone_id
}
import {
  #despite docs this cant seem to use a var (like data or otherwise)
  to = aws_route53_zone.demo_domain
  id = local.root_domain_zone_id
}
data "aws_route53_zone" "selected" {
  zone_id = local.root_domain_zone_id
}

resource "aws_route53_zone" "demo_domain" {
  name    = data.aws_route53_zone.selected.name
  comment = "Please contact field@cirlceci.com with questions"
  tags = {
    "Owner" = var.common_tags.owner
  }
}


#-------------------------------------------------------------------------------
# AWS IAM RESOURCES
# Creates an OIDC provider and an accompanying IAM role and policy
#-------------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "awesomeci" {

  url = "https://oidc.circleci.com/org/${var.circleci_org_id}"

  client_id_list = [
    var.circleci_org_id
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

#import {
# to = aws_iam_role.fe_eks
# id = "CapitalOne-fe-eks-role"
#}

resource "aws_iam_role" "fe_eks" {
  name        = "${var.fe_pipeline_iam_prefix}-role"
  description = "Role to provision and manage EKS clusters for the capitalone fe team"

  assume_role_policy = templatefile(
    "${path.module}/templates/pipeline_assume_role.json.tpl",
    {
      AWS_ACCOUNT_ID  = data.aws_caller_identity.current.id,
      CIRCLECI_ORG_ID = var.circleci_org_id
      SSO_USER_LIST   = tostring(jsonencode(local.sso_user_list))
      IAM_USER_LIST   = tostring(jsonencode(local.iam_user_list))
      SSO_TEAM_ROLE   = var.fe_sso_iam_role
      BREAK_THE_GLASS = var.break_the_glass
    }
  )

  tags = var.common_tags
}

import {
  to = aws_iam_policy.fe_eks
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.fe_pipeline_iam_prefix}-policy"
}

resource "aws_iam_policy" "fe_eks" {
  name = "${var.fe_pipeline_iam_prefix}-policy"

  description = "Policy for the capitalone team for EKS clusters"

  policy = templatefile(
    "${path.module}/templates/pipeline_role_policy.json.tpl",
    {
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id,
      DDB_TABLE_NAME = var.ddb_state_locking_table_name
    }
  )

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "fe_eks" {
  role       = aws_iam_role.fe_eks.name
  policy_arn = aws_iam_policy.fe_eks.arn
}


#
# Separate user login from pipeline stuff abgove

resource "aws_iam_role" "operator_access_role" {
  name        = "${var.fe_operator_iam_prefix}-role"
  description = "Allow humans to access EKS cluster and limited AWS resurces"

  assume_role_policy = templatefile(
    "${path.module}/templates/operator_assume_role.json.tpl",
    {
      AWS_ACCOUNT_ID  = data.aws_caller_identity.current.id,
      CIRCLECI_ORG_ID = var.circleci_org_id
      SSO_USER_LIST   = tostring(jsonencode(local.sso_user_list))
      IAM_USER_LIST   = tostring(jsonencode(local.iam_user_list))
      SSO_TEAM_ROLE   = var.fe_sso_iam_role
    }
  )

  tags = var.common_tags
}


resource "aws_iam_policy" "operator_access_policy" {
  name = "${var.fe_operator_iam_prefix}-policy"

  description = "Allow humans to access EKS cluster and limited AWS resurces"

  policy = templatefile(
    "${path.module}/templates/operator_role_policy.json.tpl",
    {
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id,
      DDB_TABLE_NAME = var.ddb_state_locking_table_name
    }
  )

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "operator_policy_attach" {
  role       = aws_iam_role.operator_access_role.name
  policy_arn = aws_iam_policy.operator_access_policy.arn
}


#module "uptime_kuma" {
# source = "git@github.com:AwesomeCICD/ceratf-module-uptime-kuma?ref=1.1.0"

#  subdomain = "status"
#target admin password from 1password, set as envvar
# kuma_admin_password = var.kuma_admin_password

#}
