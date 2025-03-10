# Kubernetes Service Account
resource "kubernetes_service_account" "filebeat_ksa" {
  metadata {
    name      = "filebeat-ksa"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = var.gcp_filebeat_sa_email
    }
  }
}

# Create the ClusterRole
resource "kubernetes_cluster_role" "filebeat_role" {
  metadata {
    name = "filebeat-gcp-role"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

# Create the ClusterRoleBinding
resource "kubernetes_cluster_role_binding" "filebeat_binding" {
  metadata {
    name = "filebeat-gcp-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.filebeat_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.filebeat_ksa.metadata[0].name
    namespace = "default"
  }
}
