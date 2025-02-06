terraform {
  backend "gcs" {
    bucket  = "shopsmart-terraform-state"  # Your GCS bucket name
    # bucket  = "shopsmart-tf-state"  # Your GCS bucket name
    prefix  = "terraform/state-files"      # Folder path inside the bucket
    credentials = "../.gcp_keys/psychic-heading-449012-r6-02d2d90bfbfe.json"
  }
}