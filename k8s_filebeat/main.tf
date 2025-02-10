# Kubernetes Service Account
resource "kubernetes_service_account" "filebeat_ksa" {
  metadata {
    name      = "filebeat-ksa"
    namespace = "default"
    annotations = {
      "iam.gke.io/gcp-service-account" = var.gcp_service_account_email
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

# GCP Credentials Secret
resource "kubernetes_secret" "filebeat_credentials" {
  metadata {
    name      = "filebeat-gcp-credentials"
    namespace = "default"
  }

  data = {
    "psychic-heading-449012-r6-71b55b565dfb.json" = file(var.gcp_credentials_file)
  }
}

module "helm_charts" {
  source = "git::https://github.com/ShopSmartSG/helm-charts.git//ELK/gcp-monitoring"
}

# Apply Filebeat Configuration
resource "kubectl_manifest" "filebeat_config" {
  yaml_body = file("${path.module}/helm_charts/filebeat-gcp-config.yaml")
}

# Apply Filebeat Deployment
resource "kubectl_manifest" "filebeat_deployment" {
  yaml_body = file("${path.module}/helm_charts/filebeat-gcp-deployment.yaml")
  depends_on = [
    kubernetes_secret.filebeat_credentials,
    kubernetes_service_account.filebeat_ksa,
    kubernetes_cluster_role_binding.filebeat_binding
  ]
}
