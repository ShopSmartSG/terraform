variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "psychic-heading-449012-r6"
}

variable "gcp_service_account_email" {
  description = "Email of the GCP service account"
  type        = string
  default     = "filebeat-sa@psychic-heading-449012-r6.iam.gserviceaccount.com"
}

variable "gcp_credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
  default     = "/etc/gcp/psychic-heading-449012-r6-71b55b565dfb.json"
}
