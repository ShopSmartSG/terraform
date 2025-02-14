resource "google_service_account" "ss_cloudsql_postgres_sa" {
  account_id   = "ss-cloudsql-postgres-sa"
  display_name = "Cloud SQL Postgres Service Account"
  project      = var.gcp_project
}

resource "google_project_iam_member" "ss_cloudsql_sa_client" {
  project = var.gcp_project
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.ss_cloudsql_postgres_sa.email}"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.ss_cloudsql_postgres_sa.name
  role    = "roles/iam.workloadIdentityUser"
  members  = [
    "serviceAccount:${var.gcp_project}.svc.id.goog[default/${var.ss_postgres_cloudsql_ksa_name}]"
  ]
}