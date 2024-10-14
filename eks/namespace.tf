resource "kubernetes_namespace" "shop_smart" {
  metadata {
    name = "shop-smart"
  }
}