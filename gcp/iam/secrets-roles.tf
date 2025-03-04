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

resource "google_service_account" "product_service_sa" {
  account_id   = "product-service-sa"
  display_name = "Product-service GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "product_service_workload_identity_binding" {
  service_account_id = google_service_account.product_service_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/product-service-ksa]"
  ]
}

resource "google_service_account" "central_hub_sa" {
  account_id   = "central-hub-sa"
  display_name = "ShopsmartSG Backend GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "central_hub_service_workload_identity_binding" {
  service_account_id = google_service_account.central_hub_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/central-hub-ksa]"
  ]
}


resource "google_service_account" "login_service_sa" {
  account_id   = "login-service-sa"
  display_name = "Login-service GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "login_service_workload_identity_binding" {
  service_account_id = google_service_account.login_service_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/login-service-ksa]"
  ]
}


resource "google_service_account" "order_service_sa" {
  account_id   = "order-service-sa"
  display_name = "Order-service GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "order_service_workload_identity_binding" {
  service_account_id = google_service_account.order_service_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/order-service-ksa]"
  ]
}


resource "google_service_account" "kibana_sa" {
  account_id   = "kibana-sa"
  display_name = "Kibana GCP Service Account"
  project      = var.gcp_project
}

resource "google_service_account_iam_binding" "kibana_workload_identity_binding" {
  service_account_id = google_service_account.kibana_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/kibana-ksa]"
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
    "serviceAccount:${google_service_account.product_service_sa.email}"
    "serviceAccount:${google_service_account.order_service_sa.email}"
    "serviceAccount:${google_service_account.login_service_sa.email}"
    "serviceAccount:${google_service_account.central_hub_sa.email}"
    "serviceAccount:${google_service_account.kibana_sa.email}"
  ])

  project = var.gcp_project
  role    = "roles/cloudsql.client"
  member  = each.value
}