variable "AWS_REGION" {
  default = "us-east-1"
}

variable "EC2_USER" {
  default = "kk-ec2"
}
variable "AMI" {
  default = {
    us-east-1 = "ami-2757f631"
  }
}

variable "SSH_PRIVATE_KEY" {
  default = "./temp/kk_key.pem"
}

variable "http_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 8080
}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
  default     = 8080
}

variable "alb_port" {
  description = "The port the elb will be listening"
  type        = number
  default     = 80
}