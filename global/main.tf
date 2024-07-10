#-------------------------------------------------------------------------------
# ROUTE 53 RESOURCES
# Creates a root zone referenced by other modules
#-------------------------------------------------------------------------------

resource "aws_route53_zone" "circleci_labs" {
  name    = "circleci-labs.com"
  comment = "Please contact solutions@cirlceci.com with questions"
  tags = {
    "Owner" = "eddie@circleci.com"
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


resource "aws_iam_role" "se_eks" {
  name        = "CapitalOne-fe-eks-role"
  description = "Role to provision and manage EKS clusters for the capitalone fe team"

  assume_role_policy = templatefile(
    "${path.module}/templates/oidc_assume_role.json.tpl",
    {
      AWS_ACCOUNT_ID  = data.aws_caller_identity.current.id,
      CIRCLECI_ORG_ID = var.circleci_org_id
      SSO_USER_LIST   = tostring(jsonencode(local.sso_user_list))
    }
  )

  tags = var.common_tags
}

resource "aws_iam_policy" "se_eks" {
  name = "CapitalOne-fe-eks-policy"

  description = "Policy for the capitalone team for EKS clusters"

  policy = templatefile(
    "${path.module}/templates/oidc_role_policy.json.tpl",
    {
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id,
      DDB_TABLE_NAME = var.ddb_state_locking_table_name
    }
  )

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "se_eks" {
  role       = aws_iam_role.se_eks.name
  policy_arn = aws_iam_policy.se_eks.arn
}


module "uptime_kuma" {
  source = "git@github.com:AwesomeCICD/ceratf-module-uptime-kuma?ref=1.1.0"

  subdomain = "status"
  #target admin password from 1password, set as envvar
  kuma_admin_password = var.kuma_admin_password

}