# resource "kubernetes_service_account" "ss_postgres_ksa" {
#   metadata {
#     name      = "ss-postgres-cloudsql-ksa"
#     namespace = "default"
#     annotations = {
#       "iam.gke.io/gcp-service-account" = var.ss_postgres_sa_email
#     }
#   }
# }

resource "kubernetes_secret" "redis_ca_cert" {
  metadata {
    name      = "redis-ca-cert"
    namespace = "default"
  }
  data = {
    "redis-ca.pem" = var.ss_redis_server_ca_pem
  }
  type = "Opaque"
}