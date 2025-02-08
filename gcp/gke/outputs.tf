output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "node_pools" {
  value = { for np in google_container_node_pool.node_pools : np.name => np.instance_group_urls }
}

output "public_ingress_static_global_ip" {
  # value = data.kubernetes_ingress_v1.public_ingress.status.0.load_balancer.0.ingress.0.ip
  value = google_compute_global_address.public_lb_ip.address
}

output "private_ingress_static_ip" {
  value = data.kubernetes_ingress_v1.private_ingress.status.0.load_balancer.0.ingress.0.ip
  # value = google_compute_address.private_lb_ip.address
}