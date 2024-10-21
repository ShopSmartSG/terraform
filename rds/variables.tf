variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}