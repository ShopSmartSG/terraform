resource "google_compute_network" "vpc" {
  name                    = "shopsmart-vpc"
  auto_create_subnetworks = false
}

# Public Subnets
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.self_link
}

# Private Subnets
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "ilb_proxy_subnet" {
  name          = "ilb-proxy-subnet"
  ip_cidr_range = "10.129.0.0/23" # Adjust range as needed
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  # purpose       = "PRIVATE"
  role          = "ACTIVE"
}

# NAT Gateway for private resources to access the internet
resource "google_compute_router" "router" {
  name    = "shopsmart-router"
  region  = var.gcp_region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "shopsmart-nat"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall Rules
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/16"]
}

resource "google_compute_firewall" "allow-external" {
  name    = "allow-external"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Allow SSH access from Google's IAP
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc.self_link  # Change if using a different VPC

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]  # Google's IAP IP range
  target_tags   = ["allow-ssh"]  # Must match instance's network tags
  direction     = "INGRESS"
  priority      = 1000
}