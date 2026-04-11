output "network_id" {
  value = yandex_vpc_network.main.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.main.id
}

output "v4_cidr_blocks" {
  value = yandex_vpc_subnet.v4_cidr_blocks
}
