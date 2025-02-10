variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "psychic-heading-449012-r6"
}

variable "gcp_service_account_id" {
  description = "GCP Service Account ID"
  type        = string
  default     = "filebeat-sa"
}

variable "pubsub_topics" {
  description = "List of PubSub topics to create"
  type        = list(string)
  default     = ["stackdriver-audit", "stackdriver-vpcflow", "stackdriver-firewall"]
}

variable "pubsub_subscriptions" {
  description = "Map of PubSub subscriptions to create"
  type        = map(string)
  default     = {
    audit    = "audit-logs-sub"
    vpcflow  = "filebeat-gcp-vpcflow"
    firewall = "filebeat-gcp-firewall"
  }
}
