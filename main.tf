provider "aws" {
  region = var.aws_region # Change this if you prefer another region
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Optional: a default value
}


# resource "aws_security_group" "allow_http" {
#   name = "allow_http_temptest"
#   description = "Allow HTTP inbound traffic"
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
#   }
# }
#
# resource "aws_instance" "test_ec2" {
#   ami           = "ami-0ad522a4a529e7aa8" # Amazon Linux 2 AMI (Free tier eligible). Update based on your region.
#   instance_type = "t2.micro"              # Free tier eligible
#
#   # Remove SSH-related key pair
#   # key_name               = aws_key_pair.deployer_key.key_name
#   security_groups        = [aws_security_group.allow_http.name]
#   associate_public_ip_address = true
#
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y httpd
#               sudo systemctl start httpd
#               sudo systemctl enable httpd
#               echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
#               EOF
#
#   tags = {
#     Name = "GitOps-Test-Instance"
#   }
# }
#
# output "instance_public_ip" {
#   value = aws_instance.test_ec2.public_ip
# }
