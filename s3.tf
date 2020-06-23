resource "aws_s3_bucket" "kk-source" {
  bucket = "kk-source"
  acl    = "private"

  tags = {
    Name        = "kk-source"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "kk-target" {
  bucket = "kk-target"
  acl    = "private"

  tags = {
    Name        = "kk-target"
    Environment = "Prod"
  }
}