resource "google_container_cluster" "gke_cluster" {
  name     = "shopsmartsg-cluster"
  # location = var.gcp_region
  location = var.gcp_zone
  network  = var.vpc_name
  subnetwork = var.private_subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  workload_identity_config {
    workload_pool = "${var.gcp_project}.svc.id.goog"
  }
  secret_manager_config {
    enabled = true
  }
  addons_config {
    http_load_balancing {
      disabled = false  # Enables the HTTP Load Balancing (Ingress) controller
    }
  }
}

resource "google_container_node_pool" "node_pools" {
  for_each = { for pool in var.node_pools : pool.name => pool }

  name       = each.value.name
  # location   = var.gcp_region
  location   = var.gcp_zone
  cluster    = google_container_cluster.gke_cluster.name
  node_count = each.value.desired_count

  depends_on = [google_container_cluster.gke_cluster]

  # autoscaling {
  #   min_node_count = each.value.min_count
  #   max_node_count = each.value.max_count
  # }

  node_locations = [var.gcp_zone]

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    service_account = var.gke_sa_email
    tags            = each.value.tags
    labels          = each.value.labels
  }
}

# IAM Binding for Workload Identity across all node pools
resource "google_service_account_iam_binding" "gke_workload_identity_binding" {
  # service_account_id = var.gke_node_sa_name
  service_account_id = var.gke_node_sa_id
  role               = "roles/iam.workloadIdentityUser"

  members = [for pool in var.node_pools :
    # "serviceAccount:${var.gcp_project}.svc.id.goog[default/${pool.name}-sa]"
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/default-sa]"
  ]
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}

# resource "kubernetes_namespace" "shop_smart" {
#   metadata {
#     name = "shop-smart"
#   }
# }
#
# resource "kubernetes_namespace" "traefik" {
#   metadata {
#     name = "traefik"
#   }
# }
