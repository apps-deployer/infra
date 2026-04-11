resource "yandex_dns_zone" "main" {
  name   = "${local.prefix}-zone"
  zone   = "${var.domain_zone}."
  public = true
}

resource "yandex_dns_recordset" "ingress_a" {
  zone_id = yandex_dns_zone.main.id
  name    = "@"
  type    = "A"
  ttl     = 300
  data    = [data.terraform_remote_state.k8s.outputs.ingress_external_ip]
}

resource "yandex_dns_recordset" "wildcard_a" {
  zone_id = yandex_dns_zone.main.id
  name    = "*"
  type    = "A"
  ttl     = 300
  data    = [data.terraform_remote_state.k8s.outputs.ingress_external_ip]
}
