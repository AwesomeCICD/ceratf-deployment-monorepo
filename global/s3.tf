

import {
  to = aws_s3_bucket.capitalone_s3_state_bucket
  id = "fe-cluster-tf-state"
}

resource "aws_s3_bucket" "capitalone_s3_state_bucket" {
  bucket                      = "fe-cluster-tf-state-capitalone"
  bucket_regional_domain_name = "s3.us-east-1.amazonaws.com"
  tags                        = var.common_tags
}