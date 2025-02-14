resource "google_redis_instance" "ss_redis_instance" {
  name               = "shopsmart-redis"         # A unique name for your Redis instance
  tier               = "BASIC"             # Use STANDARD_HA for high availability (or BASIC if you prefer)
  memory_size_gb     = 4                         # Adjust the memory size as needed
  region             = var.gcp_region            # e.g., "asia-southeast1"
  location_id        = var.gcp_zone              # e.g., "asia-southeast1-a"
  redis_version      = "REDIS_6_X"               # Choose your desired Redis version

  # The authorized_network should be the self_link of your existing VPC
  authorized_network = var.vpc_self_link

  # Optional: Enable transit encryption if desired
  transit_encryption_mode = "SERVER_AUTHENTICATION"
}