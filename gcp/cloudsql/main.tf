provider "google-beta" {
  region = var.gcp_region
  zone   = var.gcp_zone
  project = var.gcp_project
}

resource "google_compute_global_address" "cloudsql_private_ip_range" {
  provider = google-beta
  name          = "cloudsql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_id
}

resource "google_service_networking_connection" "private_vpc_sql_connection" {
  provider = google-beta
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_ip_range.name]
}

resource "google_sql_database_instance" "ss_postgres_instance" {
  provider = google-beta
  name             = "shopsmart-sqldb"
  region           = var.gcp_region
  database_version = "POSTGRES_17"

  depends_on = [google_service_networking_connection.private_vpc_sql_connection]

  settings {
    tier = "db-perf-optimized-N-2"
    disk_size = 50

    backup_configuration {
      enabled                         = true
      start_time                      = "21:00"  # Adjust as needed (UTC)
      transaction_log_retention_days  = 7
      point_in_time_recovery_enabled = true
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.vpc_self_link
      enable_private_path_for_google_cloud_services = true
      ssl_mode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_sql_database" "ss_cloudsql_postgres_prod_db" {
  name     = "shopsmartdb"
  instance = google_sql_database_instance.ss_postgres_instance.name
}

resource "google_sql_database" "ss_cloudsql_postgres_profile_db" {
  name     = "profile"
  instance = google_sql_database_instance.ss_postgres_instance.name
}

resource "google_sql_database" "ss_cloudsql_postgres_delivery_db" {
  name     = "delivery"
  instance = google_sql_database_instance.ss_postgres_instance.name
}

resource "google_sql_user" "iam_user" {
  name     = "tester1hello@gmail.com"
  instance = google_sql_database_instance.ss_postgres_instance.name
  type     = "CLOUD_IAM_USER"
}

# resource "google_sql_user" "iam_service_account_user" {
#   name     = trimsuffix(var.postgres_cloudsql_sa_email, ".gserviceaccount.com")
#   instance = google_sql_database_instance.ss_postgres_instance.name
#   type     = "CLOUD_IAM_SERVICE_ACCOUNT"
# }

resource "google_sql_user" "users" {
  name     = "ssadmin"
  instance = google_sql_database_instance.ss_postgres_instance.name
  password = "abcd1234"
}