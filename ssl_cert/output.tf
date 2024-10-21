output "certificate_arn" {
  description = "The ARN of the issued certificate"
  value       = aws_acm_certificate.ss_aws_cert.arn
}

output "certificate_body" {
  description = "The body of the issued certificate"
  value       = aws_acm_certificate.ss_aws_cert.certificate_body
}

output "certificate_private_key" {
  description = "The private key of the issued certificate"
  value       = aws_acm_certificate.ss_aws_cert.private_key
}

output "hosted_zone_id" {
  description = "The Route 53 hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}