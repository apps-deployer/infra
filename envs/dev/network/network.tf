resource "yandex_vpc_network" "main" {
  name = "${local.prefix}-vpc"
}

resource "yandex_vpc_subnet" "main" {
  name           = "${local.prefix}-subnet-a"
  v4_cidr_blocks = ["10.1.0.0/16"]
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
}
