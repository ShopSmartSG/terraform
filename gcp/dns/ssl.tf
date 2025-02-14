# provider "google" {
#   project = var.gcp_project
#   region  = var.gcp_region
# }
#
# provider "google-beta" {
#   project = var.gcp_project
#   region  = var.gcp_region
# }
#
# # Create a managed certificate
# resource "google_certificate_manager_certificate" "managed_cert" {
#   name = "shopsmartsg-public-cert"
#   provider = google-beta
#
#   managed {
#     # domains = ["*.shopsmartsg.com","shopsmartsg.com"]
#     domains = [
#       "central-hub.shopsmartsg.com",
#       "kibana.shopsmartsg.com",
#       "shopsmartsg.com"
#     ]
#     dns_authorizations = [
#       google_certificate_manager_dns_authorization.shopsmartsg_auth.id,
#       google_certificate_manager_dns_authorization.shopsmartsg_central_hub_auth.id,
#       google_certificate_manager_dns_authorization.shopsmartsg_kibana_auth.id
#     ]
#   }
# }
#
# //this is needed to authorize the DNS for the managed certificate and will provide a DNS CNAME record to be added to the DNS zone
# resource "google_certificate_manager_dns_authorization" "shopsmartsg_auth" {
#   name     = "shopsmartsg-dns-auth"
#   domain   = "shopsmartsg.com"
#   provider = google-beta
# }
# resource "google_certificate_manager_dns_authorization" "shopsmartsg_central_hub_auth" {
#   name     = "shopsmartsg-central-hub-auth"
#   domain   = "central-hub.shopsmartsg.com"
#   provider = google-beta
# }
# resource "google_certificate_manager_dns_authorization" "shopsmartsg_kibana_auth" {
#   name     = "shopsmartsg-kibana-auth"
#   domain   = "kibana.shopsmartsg.com"
#   provider = google-beta
# }
#
# //CNAME DNS records
# resource "google_dns_record_set" "central_hub_cname" {
#   name         = "_acme-challenge.central-hub.shopsmartsg.com."
#   managed_zone = google_dns_managed_zone.ss_public.name
#   type         = "CNAME"
#   ttl          = 300
#
#   rrdatas = [
#     google_certificate_manager_dns_authorization.shopsmartsg_central_hub_auth.dns_resource_record[0].data
#   ]
# }
#
# resource "google_dns_record_set" "kibana_cname" {
#   name         = "_acme-challenge.kibana.shopsmartsg.com."
#   managed_zone = google_dns_managed_zone.ss_public.name
#   type         = "CNAME"
#   ttl          = 300
#
#   rrdatas = [
#     google_certificate_manager_dns_authorization.shopsmartsg_kibana_auth.dns_resource_record[0].data
#   ]
# }
#
# resource "google_dns_record_set" "root_cname" {
#   name         = "_acme-challenge.shopsmartsg.com."
#   managed_zone = google_dns_managed_zone.ss_public.name
#   type         = "CNAME"
#   ttl          = 300
#
#   rrdatas = [
#     google_certificate_manager_dns_authorization.shopsmartsg_auth.dns_resource_record[0].data
#   ]
# }