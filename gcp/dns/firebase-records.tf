## This file is used to create the DNS records for the Firebase Hosting.
## Values are hardcded here
resource "google_dns_record_set" "app_cname" {
  name         = "app.${google_dns_managed_zone.ss_public.dns_name}"
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["_custom-domain-4a9f771e-570d-4ea6-b49d-3b49c8143430.ss-app--psychic-heading-449012-r6.asia-east1.hosted.app."]
}

resource "google_dns_record_set" "acme_challenge_cname" {
  name         = "_acme-challenge_e3n6vrwqcjz45u4s.app.shopsmartsg.com."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["26910ee7-2bb7-4bb6-9466-f95350e400fe.9.authorize.certificatemanager.goog."]
}

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
  rrdatas      = ["\"fah-claim=004-02-518d7d27-edfa-4541-97b7-70eec3062ed1\""]
}

resource "google_dns_record_set" "shopsmartsg_acme_challenge" {
  name         = "_acme-challenge_e3n6vrwqcjz45u4s.shopsmartsg.com."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_public.name
  rrdatas      = ["a7f7c39c-c5a0-421b-b524-cb041d0d025e.15.authorize.certificatemanager.goog."]
}