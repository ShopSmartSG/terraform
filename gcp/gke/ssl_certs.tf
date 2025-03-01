//public certs config
resource "kubernetes_manifest" "managed_certificate" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = local.ssl_managed_cert_name_public_ingress
      "namespace" = "default"
    }
    "spec" = {
      "domains" = [
        "central-hub.shopsmartsg.com",
        "kibana.shopsmartsg.com"
        # "shopsmart.com"
      ]
    }
  }
}

//private certs configs
# provider "tls" {
# }

# resource "tls_private_key" "internal_tls_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
#
# resource "tls_self_signed_cert" "internal_tls_cert" {
#   # key_algorithm   = tls_private_key.internal_tls_key.algorithm
#   private_key_pem = tls_private_key.internal_tls_key.private_key_pem
#
#   validity_period_hours = 8760  # Valid for 1 year
#   early_renewal_hours   = 720   # Renew 30 days before expiry
#
#   subject {
#     common_name  = "central-hub.ss.gcp.local"
#     organization = "Your Organization Name"
#   }
#
#   dns_names = [
#     "*.ss.gcp.local",
#     "central-hub.ss.gcp.local",
#     "order-service.ss.gcp.local"
#   ]
#
#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }
#
# resource "kubernetes_secret" "internal_ingress_tls_secret" {
#   metadata {
#     name      = local.ssl_managed_cert_name_private_ingress
#     namespace = "default"
#   }
#   data = {
#     "tls.crt" = base64encode(tls_self_signed_cert.internal_tls_cert.cert_pem)
#     "tls.key" = base64encode(tls_private_key.internal_tls_key.private_key_pem)
#   }
#   type = "kubernetes.io/tls"
# }