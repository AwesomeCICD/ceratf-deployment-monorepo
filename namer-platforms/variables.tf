

variable "rt_token" {
  description = "RT_TOKEN to deploy CCI Release agent to, can be exposed by setting TF_VAR_rt_token prior to runnning TF."
  type        = string
  default     = ""
  sensitive   = true
}

variable "nexus_admin_password" {
  description = "Found in 1password, global nexus adminpassword, can be exposed by setting TF_VAR_nexus_admin_password prior to runnning TF."
  type        = string
  sensitive   = true
}


variable "fe_aws_region" {
  type        = string
  description = "AWS region like 'us-west-1"
}
variable "fe_domain_region" {
  type        = string
  description = "FE region like 'namer"
}