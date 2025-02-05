output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "gke_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "node_pools" {
  value = { for np in google_container_node_pool.node_pools : np.name => np.instance_group_urls }
}
