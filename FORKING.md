## Running your own CERA

This doc assumes knowledge in stack architecture and technologies.

## Prerequisites

This runs in AWS.

- DynamoDB  Table for TF lock
- S3 Bucket for TF State
- Registed Domain pointing to an empty R53 zone.
- a Seed IAM role with rights to modify IAM

## Setup

1) Place zone id from Route53 empty zone in `globals/main.tf` locals.
2) Place bucket name in **all 3** root modules, `global`,`namer-eks`, and `namer-platforms` for **2 files** `providers.tf` and `data.tf`
3) Place DyanmoDB Table path in **all 3** root modules, `global`,`namer-eks`, and `namer-platforms` for only `providers.tf` 
4) Add the ARN of your seed role to `config.yml` and `eks-namer/main.tf`
5) Add just the NAME of your seed role to `global/main.tf`

### Initial Import

You need to import the intial IAM role and OIDC provier  - we need to clean this process up.