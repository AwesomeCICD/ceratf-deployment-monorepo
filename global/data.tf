data "aws_caller_identity" "current" {}

locals {
  sso_user_list = [for username in var.se_email_usernames : "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${var.se_sso_iam_role}/${username}@circleci.com"]
}