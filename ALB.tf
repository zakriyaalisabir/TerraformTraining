resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.prod-subnet-public-1.id,aws_subnet.prod-subnet-public-2.id]

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

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "The domain name of the load balancer"
}