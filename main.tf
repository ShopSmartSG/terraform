provider "aws" {
  region = var.aws_region # Change this if you prefer another region
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Optional: a default value
}

module "iam_roles" {
  source = "./iam_roles"
}

module "vpc" {
  source = "./vpc"
}

module "ssl_cert" {
  source = "./ssl_cert"
}

module "eks" {
  source = "./eks"
  cluster_name  = "shopsmart-cluster"
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_role_arn = module.iam_roles.eks_cluster_role_arn
  eks_cluster_role_name = module.iam_roles.eks_cluster_role_name
  eks_node_role_arn = module.iam_roles.eks_node_role_arn
  eks_node_role_name = module.iam_roles.eks_node_role_name
  vpc_main_id = module.vpc.main_vpc_id
  vpc_main_cidr_block = module.vpc.main_vpc_cidr_block
  iam_eks_cluster_policy_attachment = module.iam_roles.iam_eks_cluster_policy_attachment.policy_arn
  iam_eks_node_policy_attachment = module.iam_roles.iam_eks_node_policy_attachment.policy_arn
  iam_eks_cni_policy_attachment = module.iam_roles.iam_eks_cni_policy_attachment.policy_arn
  iam_eks_registry_policy_attachment = module.iam_roles.iam_eks_registry_policy_attachment.policy_arn
  eks_sg_id = module.vpc.eks_cluster_sg_id
  eks_nodes_sg_id = module.vpc.eks_node_sg_id
  acm_public_cert_arn = module.ssl_cert.certificate_arn
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
