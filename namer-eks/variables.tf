
variable "fe_domain_region" {
  type        = string
  description = "Friendly name for AWS region like 'namer'"
}

variable "aws_partner_product_id" {
  type        = string
  description = "AWS Partner Product ID for revenue measurement tagging"
  default     = ""
  sensitive   = true
}