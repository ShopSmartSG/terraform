locals {
  pubsub_topics = ["stackdriver-audit", "stackdriver-vpcflow", "stackdriver-firewall"]
  pubsub_subscriptions = {
    audit    = "audit-logs-sub"
    vpcflow  = "filebeat-gcp-vpcflow"
    firewall = "filebeat-gcp-firewall"
  }
}

# GCP Service Account
resource "google_service_account" "filebeat_sa" {
  account_id   = "filebeat-sa"
  display_name = "Filebeat Service Account"
  project      = var.gcp_project
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
  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.filebeat_sa.email}"
}

# PubSub Topics
resource "google_pubsub_topic" "logging_topics" {
  for_each = toset(local.pubsub_topics)
  name     = each.value
  project  = var.gcp_project
}

# PubSub Subscriptions
resource "google_pubsub_subscription" "logging_subs" {
  for_each = tomap(local.pubsub_subscriptions)
  name     = each.value
  topic    = google_pubsub_topic.logging_topics["stackdriver-${each.key}"].id
  project  = var.gcp_project
  
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
      filter = "resource.type=\"k8s_cluster\" AND logName=\"projects/${var.gcp_project}/logs/cloudaudit.googleapis.com%2Factivity\""
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
  project     = var.gcp_project
  destination = "pubsub.googleapis.com/${google_pubsub_topic.logging_topics[each.value.topic].id}"
  filter      = each.value.filter
}

# Need to add this to grant publisher permissions to Log Router Service Account
resource "google_pubsub_topic_iam_member" "log_router_publisher" {
  for_each = toset(local.pubsub_topics)
  project  = var.gcp_project
  topic    = google_pubsub_topic.logging_topics[each.key].name
  role     = "roles/pubsub.publisher"
  member   = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-logging.iam.gserviceaccount.com"
}

# Need to add explicit Workload Identity binding
resource "google_service_account_iam_binding" "filebeat_workload_identity_binding" {
  service_account_id = google_service_account.filebeat_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/${var.filebeat_kube_service_acc_name}]"
  ]
}

data "google_project" "current" {
  project_id = var.gcp_project
}
