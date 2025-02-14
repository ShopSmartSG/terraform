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
    ss_postgres_cloudsql_ksa_name = module.gke.ss_postgres_ksa_name
}

module "gke" {
    source = "./gke"
    gcp_project = var.gcp_project
    gcp_region = var.gcp_region
    gcp_zone = var.gcp_zone
    vpc_name = module.vpc.vpc_name
    ilb_proxy_subnet_id = module.vpc.ilb_proxy_subnet
    private_subnet_id = module.vpc.private_subnet
    private_subnet_name = module.vpc.private_subnet_name
    gke_sa_email = module.iam.gke_service_account_email
    gke_node_sa_name = module.iam.gke_node_sa_name
    ss_postgres_sa_email = module.iam.postgres_sa_email
    ss_redis_server_ca_pem = module.memorystore.ss_redis_memstore_ca_cert_pem
}

module "dns" {
  source = "./dns"
  gcp_project = var.gcp_project
  gcp_region = var.gcp_region
  vpc_self_link = module.vpc.vpc_self_link
  public_ingress_static_ip = module.gke.public_ingress_static_global_ip
  private_ingress_ip = module.gke.private_ingress_static_ip
  private_subnet_id = module.vpc.private_subnet
  ss_redis_host = module.memorystore.ss_redis_instance_host
}

module "cloudsql" {
  source = "./cloudsql"
  gcp_project = var.gcp_project
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  vpc_id = module.vpc.vpc_id
  vpc_self_link = module.vpc.vpc_self_link
  postgres_cloudsql_sa_email = module.iam.postgres_sa_email
}

module "memorystore" {
  source = "./memorystore"
  gcp_project = var.gcp_project
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  vpc_self_link = module.vpc.vpc_self_link
}