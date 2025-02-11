output "gke_service_account_email" {
  value = google_service_account.gke_nodes.email
}

output "gke_node_sa_name" {
  value = google_service_account.gke_nodes.name
}

output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.filebeat_sa.email
}

output "pubsub_topics" {
  description = "Created PubSub topics"
  value       = { for k, v in google_pubsub_topic.logging_topics : k => v.name }
}

output "log_sinks" {
  description = "Created log sinks"
  value       = { for k, v in google_logging_project_sink.sinks : k => v.name }
}

output "pubsub_subscriptions" {
  description = "Created PubSub subscriptions"
  value       = { for k, v in google_pubsub_subscription.logging_subs : k => v.name }
}