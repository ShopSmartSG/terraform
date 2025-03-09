variable "gcp_project" {
    description = "GCP project ID"
    type        = string
}

variable "gcp_region" {
    description = "GCP region to deploy resources"
    type        = string
}

variable "vpc_self_link" {
    description = "VPC self link"
    type        = string
}

variable "private_endpoints" {
  description = "List of private ingress rules with hostnames"
  type        = list(string)
  default     = [
    "profile-service",
    "product-service",
    "order-service",
    "login-service",
    "delivery-service",
    "utility-service",
    "kibana",
    "central-hub"
  ]
}

variable "public_endpoints" {
  description = "List of public ingress rules with service names"
  type        = list(string)
  default     = [
    "central-hub",
    "profile-service",
    "kibana"
  ]
}

variable "public_ingress_static_ip" {
    description = "Public ingress static IP"
    type        = string
}

variable "private_ingress_ip" {
    description = "Private ingress IP"
    type        = string
}

# variable "ilb_proxy_subnet_id" {
#     description = "GKE cluster private proxy ilb subnet ID"
#     type        = string
# }

variable "private_subnet_id" {
    description = "Private subnet ID"
    type        = string
}

variable "ss_redis_host" {
    description = "Redis host"
    type        = string
}
