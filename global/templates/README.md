# CERA Access

## Role Definition

Currently 1, overly permissive role is assigned to:
- THe CCI Pipelines that provision work
- The FE Admin team who assume it (_This should be a reduced scope role to just get cluster access_)
- THe EKS Nodes to interact with AWS. (_This should be a reduced scope role to just manage ec2 usage_)


## Role Assumption

The `oidc_assume_role.json.tpl` defines who/how access is granted to this role.

### Pipeline Role 

The trust relationship allows the OIDC provider we create and link to CCI organization to connect.  THis means ANY PROJECT in that org can assume this role.

See `../../.circleci/config.yml` for more.

### Humans

As operators/debuggers, we can assume same role.  


#### SSO Assumption (CCI Core)

1) List emails in `../../terraform.tfvars` as `fe_sso_emails`
2) Set the **Assumed** role users get when login via SSO as `fe_sso_iam_role` (`../../terraform.tfvars`)
3) Setup Role-Assuming profile and supporting SSO profile (if not already used for login)

** AWS Profiles for SSO Role Assumption **
```
[profile ElevatedRole]
# The FE specific role grants elevated rights and owns CERA stack
role_arn = arn:aws:iam::THISCCOUNT:role/CapitalOne-fe-eks-role  # matches role we create in  `main.tf` from this template!
role_session_name = CERA_Assumed_Session
region = us-west-2
sso_start_url = https://circleci.awsapps.com/start
sso_region = us-east-1
# We assume this role through the primary role (via a trust policy)
source_profile = company-sso-role

[profile company-sso-role]
# The 'priamry' role is the one access via SSO, same as console role.
sso_start_url = https://circleci.awsapps.com/start
sso_region = us-east-1
sso_account_id = XXX
# Can login directly to this role provided by IT.
sso_role_name = company-sso-role-0034ed37
region = us-east-2
output = json
credential_process = aws-vault exec --json
```



#### Manually created / IAM Users (Customer)


1) Provide IAM Usernames in `../../terraform.tfvars` as `fe_iam_usernames`
2) Setup Role-Assuming profile and supporting SSO profile (if not already used for login)

##### AWS Config for Manual IAM Users

```

[profile ElevatedCERAuser]
region = us-east-1
role_arn = arn:aws:iam::{THIS_ACOUNT}:role/CapitalOne-fe-eks-role  # matches role we create in  `main.tf` from this template!
role_session_name = Eddie_Pipeline_Session
source_profile = capitalone

[profile ConsoleDefinedIAMUser]
# Can login directly to this role provided by IT/CCI Team.
aws_access_key_id = XXXXXXXXX
aws_secret_access_key = XXXXXXXXXXX
region = us-east-1
```