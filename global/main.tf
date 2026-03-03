#-------------------------------------------------------------------------------
# ROUTE 53 RESOURCES
# Registering a domain creates a zone for us. 
# MANUALLY IMPORT ROOT 53 zone
#-------------------------------------------------------------------------------


resource "aws_route53_zone" "demo_domain" {
  name    = var.root_domain_name
  comment = "Please contact field@cirlceci.com with questions"
  tags = {
    "Owner" = var.common_tags.owner
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_zone" "aux_domain" {

  count   = (var.aux_domain_name != "" ? 1 : 0)
  name    = var.aux_domain_name
  comment = "Please contact field@cirlceci.com with questions"
  tags = {
    "Owner" = var.common_tags.owner
  }
  lifecycle {
    prevent_destroy = true
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

import {
  to = aws_iam_role.fe_eks
  id = "${var.fe_pipeline_iam_prefix}-role"
}

resource "aws_iam_role" "fe_eks" {
  name        = "${var.fe_pipeline_iam_prefix}-role"
  description = "Role to provision and manage EKS clusters for the fe team"

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
  lifecycle {
    create_before_destroy = true
  }
}

# import {
#   to = aws_iam_policy.fe_eks
#   id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.fe_pipeline_iam_prefix}-policy"
# }

resource "aws_iam_policy" "fe_eks" {
  name = "${var.fe_pipeline_iam_prefix}-policy"

  description = "Policy for the admin team for EKS clusters"

  policy = templatefile(
    "${path.module}/templates/pipeline_role_policy.json.tpl",
    {
      AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id,
      DDB_TABLE_NAME = var.ddb_state_locking_table_name
      AWS_REGION     = data.aws_region.current.name
    }
  )

  tags = var.common_tags

}

resource "aws_iam_role_policy_attachment" "fe_eks" {
  role       = aws_iam_role.fe_eks.name
  policy_arn = aws_iam_policy.fe_eks.arn
}


#
# Separate user login from pipeline role above

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
      AWS_REGION     = data.aws_region.current.name
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


#-------------------------------------------------------------------------------
# CIRCLECI AUDIT LOG STREAMING - S3 BUCKET
# Receives streaming audit logs from the CircleCI org.
# Downstream: a loader script pulls JSON from here into Postgres for Grafana.
#-------------------------------------------------------------------------------

resource "aws_s3_bucket" "audit_logs" {
  bucket = var.audit_log_bucket_name
  tags = merge(var.common_tags, {
    "purpose" = "CircleCI audit log streaming destination"
  })
}

resource "aws_s3_bucket_versioning" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "audit_logs" {
  bucket                  = aws_s3_bucket.audit_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_policy" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCircleCIAuditLogDelivery"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.fe_eks.arn
        }
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.audit_logs.arn,
          "${aws_s3_bucket.audit_logs.arn}/*"
        ]
      }
    ]
  })
}
