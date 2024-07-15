## Running your own CERA

This doc assumes knowledge in stack architecture and technologies.

## Prerequisites

This runs in AWS. Manually (or have your IT team) create these resources.

- DynamoDB  Table for TF lock (see providers.tf for name)
- S3 Bucket for TF State (see providers.tf for name)
- Registed Domain pointing to an empty R53 zone. 
- a Seed IAM role you can login with rights to modify IAM (so you can create role and oidc)

## Setup

1) Determine Root Zone ID for Domain.
  1) When creating a new domain in AWS R53, a zone is automatically created.
  2) If existing domain, set a R53 record with those DNS servers and grab zone_id
3) Create initial seed Role and OIDC Provider (see `global/templates/README.md`)
4) Import root dns from `global` module `terraform import aws_route53_zone.demo_domain ZONEIDZXXXX`
5) Fill all values in `global/terraform.tfvars`

### If changing region, or other advanced state changes that rename bucket 

 Rename bucket, dyanmo, or region in **all 3** root modules, `global`,`namer-eks`,`namer-platforms`  in both of **2 files** `providers.tf` and `data.tf`


### Initial Import

You need to import the intial IAM role and OIDC provier  - we need to clean this process up.