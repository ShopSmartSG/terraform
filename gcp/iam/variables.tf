variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "ss_postgres_cloudsql_ksa_name" {
    description = "Kubernetes Service Account Name for PostgreSQL Cloud SQL"
    type        = string
}

variable "filebeat_kube_service_acc_name" {
    description = "Name of the Kubernetes Service Account for Filebeat"
    type        = string
}