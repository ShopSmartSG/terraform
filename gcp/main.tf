provider "google" {
  # credentials = file("<path-to-your-service-account-key>.json")
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = file(var.gcp_cred)
}

variable "gcp_region" {
    description = "GCP region to deploy resources"
    type        = string
    default     = "asia-southeast1"
}

variable "gcp_zone" {
    description = "GCP zone to deploy resources"
    type        = string
    default     = "asia-southeast1-a"
}

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_cred" {
    description = "GCP service account credentials"
    type        = string
}

//actual resources will be defined here
module "vpc" {
  source = "./vpc"
  gcp_region = var.gcp_region
  gcp_project = var.gcp_project
}

module "iam" {
  source = "./iam"
    gcp_project = var.gcp_project
}

module "gke" {
    source = "./gke"
    gcp_project = var.gcp_project
    gcp_region = var.gcp_region
    gcp_zone = var.gcp_zone
    vpc_name = module.vpc.vpc_name
    ilb_proxy_subnet_id = module.vpc.ilb_proxy_subnet
    private_subnet_name = module.vpc.private_subnet_name
    gke_sa_email = module.iam.gke_service_account_email
    gke_node_sa_name = module.iam.gke_node_sa_name
}