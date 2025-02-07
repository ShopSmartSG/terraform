# provider "kubernetes" {
#   host                   = google_container_cluster.primary.endpoint
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
# }

resource "google_compute_global_address" "public_ip" {
  name         = "shopsmartsg-public-ip"
  description  = "Static IP address for public ingress"
  purpose      = "VIP"
  address_type = "EXTERNAL"
}

# Public Ingress Setup
resource "kubernetes_ingress_v1" "public_ingress" {
  metadata {
    name      = "public-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.public_ip.name
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.public_endpoints
      content {
        host = "${rule.value.name}.shopsmartsg.com"
        http {
          path {
            path      = "/"
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


# Private Ingress Setup
resource "kubernetes_ingress_v1" "private_ingress" {
  metadata {
    name      = "private-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "gce-internal"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.private_endpoints
      content {
        host = "${rule.value.name}.ss.gcp.local"
        http {
          path {
            path      = "/"
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
  }

  depends_on = [var.ilb_proxy_subnet_id]
}




# Public Load Balancer Setup
# resource "kubernetes_service" "public_lb" {
#   for_each = { for svc in var.public_endpoints : svc.name => svc }
#
#   metadata {
#     name      = "${each.value.name}-svc"
#     namespace = "default"
#     annotations = {
#       "cloud.google.com/load-balancer-type" = "External"
#     }
#   }
#
#   spec {
#     selector = {
#       "nodegroup" = "public-nodegroup"
#     }
#
#     port {
#       port        = each.value.port
#       target_port = each.value.targetPort
#     }
#
#     type = "LoadBalancer"
#   }
# }

# Private Internal Load Balancer Setup
# resource "kubernetes_service" "private_lb" {
#   for_each = { for svc in var.private_endpoints : svc.name => svc }
#
#   metadata {
#     name      = "${each.value.name}-svc"
#     namespace = "default"
#     annotations = {
#       "cloud.google.com/load-balancer-type" = "Internal"
#     }
#   }
#
#   spec {
#     selector = {
#       "nodegroup" = "private-nodegroup"
#     }
#
#     port {
#       port        = each.value.port
#       target_port = each.value.targetPort
#     }
#
#     type = "LoadBalancer"
#   }
# }