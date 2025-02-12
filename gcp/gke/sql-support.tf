resource "kubernetes_service_account" "ss_postgres_ksa" {
  metadata {
    name      = "ss-postgres-cloudsql-ksa"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = var.ss_postgres_sa_email
    }
  }
}