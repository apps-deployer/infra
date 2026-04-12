resource "yandex_vpc_network" "main" {
  name        = "${local.prefix}-vpc"
  description = "Основная сеть проекта"
}

resource "yandex_vpc_subnet" "main" {
  name           = "${local.prefix}-subnet-a"
  description    = "Основная подсеть в зоне ru-central1-a"
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
}

resource "yandex_vpc_address" "ingress" {
  name        = "${local.prefix}-ingress-ip"
  description = "Статический внешний IP для Ingress-контроллера (Traefik)"
  external_ipv4_address {
    zone_id = var.zone
  }
}
