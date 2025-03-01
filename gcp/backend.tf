terraform {
  backend "gcs" {
    bucket  = "shopsmart-tf-state"  # Your GCS bucket name
    # bucket  = "shopsmart-tf-state"  # Your GCS bucket name
    prefix  = "terraform/state-files"      # Folder path inside the bucket
    credentials = "../.gcp_keys/shopsmartsg-451708-ab89c5369bfd.json"
  }
}