resource "aws_instance" "web1" {
  ami           = "${lookup(var.AMI, var.AWS_REGION)}"
  instance_type = "t2.micro"
  # VPC
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  key_name = "kk_key"
  user_data = "${file("userdata.sh")}"
  tags = {
    Name = "web1"
  }
  connection {
    type        = "ssh"
    user        = "${var.EC2_USER}"
    host        = "self.public_ip"
    private_key = "${file("${var.SSH_PRIVATE_KEY}")}"
  }
}

output "public_ip" {
  value       = aws_instance.web1.public_ip
  description = "The public IP of the web server"
}