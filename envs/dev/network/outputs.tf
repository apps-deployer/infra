output "network_id" {
  value = yandex_vpc_network.main.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.main.id
}

output "v4_cidr_blocks" {
  value = yandex_vpc_subnet.main.v4_cidr_blocks
}

output "ingress_external_ip" {
  value = yandex_vpc_address.ingress.external_ipv4_address[0].address
}
