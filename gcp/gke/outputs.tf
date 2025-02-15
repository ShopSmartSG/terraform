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
  value = data.kubernetes_ingress_v1.public_ingress.status.0.load_balancer.0.ingress.0.ip
  # value = google_compute_global_address.public_lb_ip.address
}

output "private_ingress_static_ip" {
  value = data.kubernetes_ingress_v1.private_ingress.status.0.load_balancer.0.ingress.0.ip
}

output "ss_postgres_ksa_name"{
    value = kubernetes_service_account.ss_postgres_ksa.metadata.0.name
}

output "filebeat_ksa_name" {
  description = "Name of the created Kubernetes service account"
  value       = kubernetes_service_account.filebeat_ksa.metadata[0].name
}