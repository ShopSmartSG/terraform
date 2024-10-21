resource "aws_route53_zone" "main" {
  name = "ss.aws.com"
}

resource "aws_route53_zone" "ss_private" {
  name = "ss.aws.local"
  vpc {
    vpc_id = var.vpc_id  # Replace with your VPC ID
  }
}