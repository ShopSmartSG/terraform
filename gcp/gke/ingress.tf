locals {
  ssl_managed_cert_name = "shopsmartsg-public-cert"
  static_public_ingress_ip_name = "shopsmart-public-ingress-ip"
}

# this is no longer needed as the IP was manually set in GCP console and we are directly referencing it in the ingress
# resource "google_compute_global_address" "public_lb_ip" {
#   name         = "shopsmartsg-public-lb-ip"
#   description  = "Static IP address for public ingress"
#   purpose      = "VIP"
#   address_type = "EXTERNAL"
# }

# Public Ingress Setup
resource "kubernetes_ingress_v1" "public_ingress" {
  metadata {
    name      = "public-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = local.static_public_ingress_ip_name
      # "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.public_lb_ip.name
      "networking.gke.io/managed-certificates" = local.ssl_managed_cert_name
    }
  }

  spec {
    # tls {
    #   hosts = ["*.shopsmartsg.com", "shopsmartsg.com"]
    #   secret_name = "tls-cert-secret"
    # }

    dynamic "rule" {
      for_each = var.public_endpoints
      content {
        host = "${rule.value.name}.shopsmartsg.com"
        http {
          path {
            path      = "/*"
            path_type = "ImplementationSpecific"
            backend {
              service {
                name = rule.value.name
                port {
                  number = rule.value.port
                }
              }
            }
          }
        }
      }
    }
    default_backend {
      service {
        name = "central-hub"
        port {
          number = 82
        }
      }
    }
  }
}

resource "kubernetes_manifest" "managed_certificate" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = local.ssl_managed_cert_name
      "namespace" = "default"
    }
    "spec" = {
      "domains" = [
        "central-hub.shopsmartsg.com",
        "kibana.shopsmartsg.com"
        # "shopsmartsg.com"
      ]
    }
  }
}

resource "google_compute_address" "private_lb_ip" {
  name          = "private-lb-ip"
  subnetwork    = var.private_subnet_id
  address_type  = "INTERNAL"
  purpose       = "SHARED_LOADBALANCER_VIP"

}


# Private Ingress Setup
resource "kubernetes_ingress_v1" "private_ingress" {
  metadata {
    name      = "private-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "gce-internal"
      "networking.gke.io/internal-load-balancer-vip" = google_compute_address.private_lb_ip.address
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.private_endpoints
      content {
        host = "${rule.value.name}.ss.gcp.local"
        http {
          path {
            path      = "/*"
            path_type = "ImplementationSpecific"
            backend {
              service {
                name = rule.value.name
                port {
                  number = rule.value.port
                }
              }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "central-hub"
        port {
          number = 82
        }
      }
    }
  }

  # depends_on = [var.ilb_proxy_subnet_id]
}

data "kubernetes_ingress_v1" "private_ingress" {
  metadata {
    name = "private-ingress"
  }
}

data "kubernetes_ingress_v1" "public_ingress" {
  metadata {
    name = "public-ingress"
  }
}