# ceratf-deployment-global
Infrastructure code for global resources used by SE EKS clusters.

This plan is executed with AWS access keys stored at the project-level environment level.  

Includes the following resources:
* IAM role used for accessing EKS clusters (SolutionsEngineeringEKS)
* IAM policy attached to the above role
* OIDC provider for access from AwesomeCI Github org

### Requirements

The following variables must be configured in CircleCI at the project level:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.awesomeci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.se_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.se_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.se_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_zone.circleci_labs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_circleci_org_id"></a> [circleci\_org\_id](#input\_circleci\_org\_id) | CircleCI org ID whose jobs will be authenticating via OIDC. | `any` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags to be applied to all resources. | `any` | n/a | yes |
| <a name="input_ddb_state_locking_table_name"></a> [ddb\_state\_locking\_table\_name](#input\_ddb\_state\_locking\_table\_name) | Name of DynamoDB table used for state locking. | `any` | n/a | yes |
| <a name="input_se_email_usernames"></a> [se\_email\_usernames](#input\_se\_email\_usernames) | List of SE team members' email usernames. | `any` | n/a | yes |
| <a name="input_se_sso_iam_role"></a> [se\_sso\_iam\_role](#input\_se\_sso\_iam\_role) | Name of AWS IAM SSO role to be used for EKS auth by SE team. | `string` | `"AWSReservedSSO_LimitedAdmin_bfe1dfbf15bdb9c9"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_circleci_org_id"></a> [circleci\_org\_id](#output\_circleci\_org\_id) | ## Variable values ### |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | n/a |
| <a name="output_eks_access_iam_role_arn"></a> [eks\_access\_iam\_role\_arn](#output\_eks\_access\_iam\_role\_arn) | n/a |
| <a name="output_eks_access_iam_role_name"></a> [eks\_access\_iam\_role\_name](#output\_eks\_access\_iam\_role\_name) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ## Created resource values ### |
| <a name="output_r53_root_zone_id"></a> [r53\_root\_zone\_id](#output\_r53\_root\_zone\_id) | n/a |
| <a name="output_r53_root_zone_name"></a> [r53\_root\_zone\_name](#output\_r53\_root\_zone\_name) | n/a |
| <a name="output_se_email_usernames"></a> [se\_email\_usernames](#output\_se\_email\_usernames) | n/a |