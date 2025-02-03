provider "google" {
  # credentials = file("<path-to-your-service-account-key>.json")
  project     = var.gcp_project  # Replace with your GCP project ID
  region      = "asia-southeast1"    # Replace with your desired region
  zone        = "asia-southeast1-a"  # Replace with your desired zone
  credentials = file(var.gcp_cred)
}

variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_cred" {
    description = "GCP service account credentials"
    type        = string
}

//generate eks cluster
