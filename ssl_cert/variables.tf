# variable "route53_zone_id" {
#   description = "The ID of the Route 53 hosted zone"
#   type        = string
# }

variable "rds_endpoint" {
  description = "The RDS endpoint"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}