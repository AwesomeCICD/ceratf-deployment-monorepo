

resource "aws_s3_bucket" "capitalone_s3_state_bucket" {
  bucket = "fe-cluster-tf-state"
  tags   = var.common_tags
}