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


#### Initial Pipeline seed
bit of a chicken and egg, pipeline manages the policy it uses.  

Fortunately it will import a seed you can manually create.  Easiest to give it admin rights (or highest you can) and then it will apply whats in this template immediated.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:oidc-provider/oidc.circleci.com/org/CCI_ORG_ID"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.circleci.com/org/CCI_ORG_ID:aud": "CCI_ORG_ID"
                }
            }
        }
    ]
}
```



### Humans

As operators/debuggers, we can assume same role.  


#### SSO Assumption (CCI Core)

1) List emails in `../../terraform.tfvars` as `fe_sso_emails`
2) Set the **Assumed** role users get when login via SSO as `fe_sso_iam_role` (`../../terraform.tfvars`)
3) Setup Role-Assuming profile and supporting SSO profile (if not already used for login)

##### AWS Profiles for SSO Role Assumption **

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


1) Create IAM Users via console,basic rights needed
2) Provide IAM Usernames in `../../terraform.tfvars` as `fe_iam_usernames`
3) Setup Role-Assuming profile and supporting SSO profile (if not already used for login)

##### AWS Config for Manual IAM Users

```

[profile ElevatedCERAuser]
region = us-east-1
role_arn = arn:aws:iam::{THIS_ACOUNT}:role/Customer-fe-eks-role  # matches role we create in  `main.tf` from this template!
role_session_name = Eddie_Pipeline_Session
source_profile = ConsoleDefinedIAMUser

[profile ConsoleDefinedIAMUser]
# Can login directly to this role provided by IT/CCI Team.
aws_access_key_id = XXXXXXXXX
aws_secret_access_key = XXXXXXXXXXX
region = us-east-1
```



## Cluster Access

The overloaded policy above is also given to the EKS modules as as those with cluster admin rights.

the `region-eks` job `apply` step will output something like this allowing `kubectl` to connect:

```
      aws eks update-kubeconfig --name cera-use1-namer --region us-east-1  # Confirm Region and Name
      kubectl config rename-context arn:aws:eks:us-east-1:ACCOUNT:cluster/cera-use1-namer cera-use1-namer
      kubectl config set-context cera-use1-namer
```