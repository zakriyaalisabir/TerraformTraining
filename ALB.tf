resource "aws_lb" "test" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-alb.id}"]
  subnets            = ["${aws_subnet.prod-subnet-public-1.id}"]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.kk-logs.bucket
    prefix  = "alb-logs/"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}