resource "google_dns_managed_zone" "ss_public" {
  name        = "shopsmartsg-dns-zone"
  dns_name    = "shopsmartsg.com."
  description = "DNS Zone for shopsmartsg.com"

  dnssec_config {
    state = "on"
    non_existence = "nsec3" # Enables NSEC3 for better security
    default_key_specs {
      key_type    = "keySigning"
      algorithm   = "rsasha256"
      key_length  = 2048
    }
    default_key_specs {
      key_type    = "zoneSigning"
      algorithm   = "rsasha256"
      key_length  = 1024
    }
  }
}

resource "google_dns_managed_zone" "ss_private" {
  name        = "private-gcp-zone"
  dns_name    = "ss.gcp.local."
  description = "Private DNS zone for internal GKE service and resources communication"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.vpc_self_link
    }
  }
}

resource "google_dns_record_set" "public_service_endpoints" {
  for_each = toset(var.public_endpoints)

  name    = "${each.value}.${google_dns_managed_zone.ss_public.dns_name}"
  type    = "A"
  ttl     = 300
  managed_zone = google_dns_managed_zone.ss_public.name

  rrdatas = [var.public_ingress_static_ip]
}

resource "google_dns_record_set" "private_service_endpoints" {
  for_each = toset(var.private_endpoints)

  name         = "${each.value}.${google_dns_managed_zone.ss_private.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_private.name

  rrdatas = [var.private_ingress_ip]
}
// in case other endpoints to be supported, like for redis or postgresdb or mongo, use rrdata as var.private_subnet_id
resource "google_dns_record_set" "ss_redis_endpoint" {

  name         = "redis.${google_dns_managed_zone.ss_private.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.ss_private.name

  rrdatas = [var.ss_redis_host]
}