output "gke_service_account_email" {
  value = google_service_account.gke_nodes.email
}

output "gke_node_sa_name" {
  value = google_service_account.gke_nodes.name
}

output "gke_node_sa_id" {
  value = google_service_account.gke_nodes.id
}

# output "postgres_sa_email" {
#   value = google_service_account.ss_cloudsql_postgres_sa.email
# }

output "filebeat_sa_email" {
  description = "Email of the created filebeat service account"
  value       = google_service_account.filebeat_sa.email
}