variable "gcp_project" {
    description = "The GCP project ID"
    type        = string
}

variable "vpc_id" {
    description = "The VPC network to deploy the Cloud SQL instance"
    type        = string
}

variable "vpc_self_link" {
    description = "The VPC network self link to deploy the Cloud SQL instance"
    type        = string
}

variable "gcp_region" {
    description = "The GCP region to deploy the Cloud SQL instance"
    type        = string
}

variable "gcp_zone" {
    description = "The GCP zone to deploy the Cloud SQL instance"
    type        = string
}

variable "postgres_cloudsql_sa_email" {
    description = "The email of the Cloud SQL service account"
    type        = string
}