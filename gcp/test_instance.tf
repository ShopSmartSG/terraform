resource "google_compute_instance" "test_instance" {
  name         = "test-ss-instance-with-tags"
  machine_type = "e2-micro"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = module.vpc.vpc_self_link
    subnetwork = module.vpc.private_subnet
    access_config {}
  }

  # network_interface {
  #   network = module.vpc.vpc_self_link
  #   subnetwork = module.vpc.ilb_proxy_subnet
  #   access_config {}
  # }

  tags = ["allow-ssh", "allow-smtp"] # Match this tag in the firewall rule
}

resource "google_compute_firewall" "ssh_firewall_test" {
  name    = "allow-ssh-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"] # Applies only to instances with this tag
}