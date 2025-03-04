resource "google_service_account" "profile_service_sa" {
  account_id   = "profile-service-sa"
  display_name = "Profile-service GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "prof_service_workload_identity_binding" {
  service_account_id = google_service_account.profile_service_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/profile-service-ksa]"
  ]
}

# resource "google_secret_manager_secret_iam_member" "prof_service_secret_accessor_binding" {
#   secret_id = "profile-service-google-maps-api-key"
#   project      = var.gcp_project
#   member = "serviceAccount:${google_service_account.delivery_service_sa.email}"
#   role    = "roles/secretmanager.secretAccessor"
# }

resource "google_service_account" "delivery_service_sa" {
  account_id   = "delivery-service-sa"
  display_name = "Delivery-service GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "del_service_workload_identity_binding" {
  service_account_id = google_service_account.delivery_service_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/delivery-service-ksa]"
  ]
}

# resource "google_secret_manager_secret_iam_member" "del_service_secret_accessor_binding" {
#   secret_id = "delivery-service-google-maps-api-key"
#   project      = var.gcp_project
#   member = "serviceAccount:${google_service_account.delivery_service_sa.email}"
#   role    = "roles/secretmanager.secretAccessor"
# }

# resource "google_project_iam_member" "services_sa_clients" {
#   for_each = toset([
#     "serviceAccount:${google_service_account.delivery_service_sa.email}",
#     "serviceAccount:${google_service_account.profile_service_sa.email}"
#   ])
#
#   project = var.gcp_project
#   role    = "roles/secretmanager.secretAccessor"
#   member  = each.value
# }

resource "google_project_iam_member" "services_cloudsql_sa_clients" {
  for_each = toset([
    "serviceAccount:${google_service_account.delivery_service_sa.email}",
    "serviceAccount:${google_service_account.profile_service_sa.email}"
  ])

  project = var.gcp_project
  role    = "roles/cloudsql.client"
  member  = each.value
}