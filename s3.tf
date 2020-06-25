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


resource "aws_s3_bucket" "kk-logs" {
  bucket = "kk-logs"
  acl    = "private"

  tags = {
    Name        = "kk-logs"
    Environment = "Prod"
  }
}


resource "aws_s3_bucket_notification" "my-trigger" {
  bucket = "${aws_s3_bucket.kk-source.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.test_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = ""
    filter_suffix       = ".txt"
  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::kk-source"
}