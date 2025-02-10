output "filebeat_service_account" {
  description = "Name of the created Kubernetes service account"
  value       = kubernetes_service_account.filebeat_ksa.metadata[0].name
}

output "filebeat_secret" {
  description = "Name of the created secret"
  value       = kubernetes_secret.filebeat_credentials.metadata[0].name
}
