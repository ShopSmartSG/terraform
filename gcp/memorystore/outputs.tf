output "ss_redis_instance_host" {
  value = google_redis_instance.ss_redis_instance.host
}

output "ss_redis_memstore_ca_cert_pem" {
  value = google_redis_instance.ss_redis_instance.server_ca_certs.0.cert
}