output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "public_subnet" {
  value = google_compute_subnetwork.public_subnet.id
}

output "public_subnet_name" {
  value = google_compute_subnetwork.public_subnet.name
}

output "private_subnet" {
  value = google_compute_subnetwork.private_subnet.id
}

output "private_subnet_name" {
  value = google_compute_subnetwork.private_subnet.name
}

output "ilb_proxy_subnet" {
  value = google_compute_subnetwork.ilb_proxy_subnet.id
}