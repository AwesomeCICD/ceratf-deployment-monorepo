## Running your own CERA

This doc assumes knowledge in stack architecture and technologies.

## Prerequisites

This runs in AWS.

- DynamoDB  Table for TF lock
- S3 Bucket for TF State
- Registed Domain pointing to an empty R53 zone.
- a Seed IAM role with rights to modify IAM

## Setup

1) Determine Root Zone ID for Domain.
  1) When creating a new domain in AWS R53, a zone is automatically created.
  2) If existing domain, set a R53 record with those DNS servers and grab zone_id
2) Import root dns from `global` module `terraform import aws_route53_zone.demo_domain ZONEIDZXXXX`
3) Fill all values in `global/terraform.tfvars`

### If adding multiple per region, or other advanced state changes
3) Place bucket name in **all 3** root modules, `global`,`namer-eks`, and `namer-platforms` for **2 files** `providers.tf` and `data.tf`
4) Place DyanmoDB Table path in **all 3** root modules, `global`,`namer-eks`, and `namer-platforms` for only `providers.tf` 

### Initial Import

You need to import the intial IAM role and OIDC provier  - we need to clean this process up.