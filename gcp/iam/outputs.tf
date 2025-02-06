output "gke_service_account_email" {
  value = google_service_account.gke_nodes.email
}

output "gke_node_sa_name" {
  value = google_service_account.gke_nodes.name
}