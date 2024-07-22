data "aws_caller_identity" "current" {}

locals {
  sso_user_list = [for username in var.fe_email_usernames : "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${var.fe_sso_iam_role}/${username}@circleci.com"]

  iam_user_list = [for username in var.fe_iam_usernames : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${username}"]

}