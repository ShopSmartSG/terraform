## This file is used to create the DNS records for the Firebase Hosting.
## Values are hardcded here
resource "google_dns_record_set" "app_cname" {
  name         = "app.${google_dns_managed_zone.ss_public.dns_name}"
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["_custom-domain-84de1635-bb9c-406e-a3c1-a2146876bc07.shopsmartsg--shopsmartsg-451708.asia-east1.hosted.app."]
}
#
# resource "google_dns_record_set" "acme_challenge_cname" {
#   name         = "_acme-challenge_hmldfqc22cnstnx2.app.shopsmart.com."
#   type         = "CNAME"
#   ttl          = 300
#   managed_zone = google_dns_managed_zone.ss_public.name
#   rrdatas      = ["a105c827-9f17-4a89-98a1-d2f13a1ff258.14.authorize.certificatemanager.goog."]
# }

resource "google_dns_record_set" "shopsmartsg_a" {
  name         = "shopsmartsg.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["35.219.200.56"]
}

resource "google_dns_record_set" "shopsmartsg_txt" {
  name         = "shopsmartsg.com."
  type         = "TXT"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["\"fah-claim=004-02-7a60007a-27ac-40c1-adee-dc82deb73970\""]
}
#
# resource "google_dns_record_set" "shopsmartsg_acme_challenge" {
#   name         = "_acme-challenge_hmldfqc22cnstnx2.shopsmart.com."
#   type         = "CNAME"
#   ttl          = 300
#   managed_zone = google_dns_managed_zone.ss_public.name
#   rrdatas      = ["e86ca768-2026-48a6-9fe2-174c4b8b51d2.12.authorize.certificatemanager.goog."]
# }