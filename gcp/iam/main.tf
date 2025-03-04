# Create GKE Service Account
resource "google_service_account" "gke_nodes" {
  account_id   = "gke-nodes"
  display_name = "GKE Nodes Service Account"
}

# IAM Roles for GKE Nodes
resource "google_project_iam_member" "gke_compute" {
  project = var.gcp_project
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_network" {
  project = var.gcp_project
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_logging" {
  project = var.gcp_project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_monitoring" {
  project = var.gcp_project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Workload Identity Binding (Enables Kubernetes workloads to use GCP IAM)
# resource "google_project_iam_member" "gke_workload_identity" {
#   project = var.gcp_project
#   role    = "roles/iam.workloadIdentityUser"
#   member  = "serviceAccount:${google_service_account.gke_nodes.email}"
# }
resource "google_project_iam_member" "gke_workload_identity_user" {
  project = var.gcp_project
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.gcp_project}.svc.id.goog[default/default-sa]"
}

resource "google_service_account_iam_binding" "gke_workload_identity_binding" {
  service_account_id = google_service_account.gke_nodes.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/default-sa]"
  ]
}


resource "google_project_iam_member" "gke_nodes_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",  # Needed for GKE nodes
    "roles/artifactregistry.reader",      # Allow pulling images from Artifact Registry
    "roles/logging.logWriter",           # Allow writing logs to Cloud Logging
    "roles/monitoring.metricWriter",      # Allow sending metrics to Cloud Monitoring
    "roles/storage.objectViewer",         # Allow reading from Cloud Storage
  ])

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}