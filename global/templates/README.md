# CERA Access

## Role Definition

Currently 1, overly permissive role is assigned to:
- THe CCI Pipelines that provision work
- The FE Admin team who assume it
- THe EKS Nodes to interact with AWS.


## Role Assumption

### Pipeline

The trust relationship allows the OIDC provider we create and link to CCI organization to connect.  THis means ANY PROJECT in that org can assume this role.


### Humans

As operators/debuggers, we can assume same role.

#### SSO Assumption = prferred

List emails and assumed role pattern in `data.tf`

#### Manually created / IAM Users

List full user arn in `data.tf`