variable "gcp_project"{
    description = "GCP project ID"
    type = string
}

variable "gcp_region"{
    description = "GCP region to deploy resources"
    type = string
}

variable "gcp_zone" {
    description = "GCP zone to deploy resources"
    type = string
}

variable "vpc_self_link" {
    description = "VPC self link"
    type = string
}