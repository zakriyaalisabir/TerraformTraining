resource "aws_alb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg-alb.id}"]
  subnets            = ["${aws_subnet.prod-subnet-public-1.id}"]

  enable_deletion_protection = true

  # listner {
  #   instance_port = 80
  #   instance_protocol = "http"
  # }

  access_logs {
    bucket  = aws_s3_bucket.kk-logs.bucket
    prefix  = "alb-logs/"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "" "name" {
  
}

output "elb_dns_name" {
  value       = aws_alb.alb.dns_name
  description = "The domain name of the load balancer"
}