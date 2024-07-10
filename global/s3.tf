

#import {
 # to = aws_s3_bucket.capitalone_s3_state_bucket
  #id = "fe-tf-cluster-capitalone"
#}

resource "aws_s3_bucket" "capitalone_s3_state_bucket" {
  bucket = "fe-tf-cluster-capitalone"
  tags   = var.common_tags
}