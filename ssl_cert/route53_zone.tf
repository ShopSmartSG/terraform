resource "aws_route53_zone" "main" {
  name = "ss.aws.com"
}

resource "aws_route53_zone" "ss_private" {
  name = "ss.aws.com"
  vpc {
    vpc_id = var.vpc_id  # Replace with your VPC ID
  }
}

resource "aws_route53_record" "rds_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "postgres01.ss.aws.com"
  type    = "CNAME"
  ttl     = 300
  records = [var.rds_endpoint]
}