provider "kubectl" {
  config_path = "~/.kube/config"
}

# GCP Service Account
resource "google_service_account" "filebeat_sa" {
  account_id   = var.gcp_service_account_id
  display_name = "Filebeat Service Account"
  project      = var.project_id
}

# IAM Roles
resource "google_project_iam_member" "filebeat_roles" {
  for_each = toset([
    "roles/container.viewer",
    "roles/iam.workloadIdentityUser",
    "roles/logging.viewer",
    "roles/pubsub.admin",
    "roles/pubsub.publisher",
    "roles/pubsub.subscriber",
    "roles/pubsub.viewer"
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.filebeat_sa.email}"
}

# PubSub Topics
resource "google_pubsub_topic" "logging_topics" {
  for_each = toset(var.pubsub_topics)
  name     = each.value
  project  = var.project_id
}

# PubSub Subscriptions
resource "google_pubsub_subscription" "logging_subs" {
  for_each = var.pubsub_subscriptions
  name     = each.value
  topic    = google_pubsub_topic.logging_topics[each.key].name
  project  = var.project_id
  
  ack_deadline_seconds = 10
  message_retention_duration = "604800s"  # 7 days
  expiration_policy {
    ttl = "2678400s"  # 31 days
  }
}

# Log Sinks
resource "google_logging_project_sink" "sinks" {
  for_each = {
    audit = {
      filter = "resource.type=\"k8s_cluster\" AND logName=\"projects/${var.project_id}/logs/cloudaudit.googleapis.com%2Factivity\""
      topic = "stackdriver-audit"
    }
    vpc = {
      filter = "resource.type=\"gce_subnetwork\""
      topic = "stackdriver-vpcflow"
    }
    firewall = {
      filter = "log_id(\"compute.googleapis.com/firewall\")"
      topic = "stackdriver-firewall"
    }
  }
  
  name        = "${each.key}-logs-sink"
  project     = var.project_id
  destination = "pubsub.googleapis.com/${google_pubsub_topic.logging_topics[each.key].id}"
  filter      = each.value.filter
}
