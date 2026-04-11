resource "yandex_vpc_address" "ingress" {
  name = "${local.prefix}-ingress-ip"
  external_ipv4_address {
    zone_id = var.zone
  }
}

resource "yandex_vpc_security_group" "k8s_common" {
  name        = "${local.prefix}-k8s-common-sg"
  description = "Общие правила для мастера и рабочих узлов: внутрикластерное взаимодействие и исходящий трафик"
  network_id  = data.terraform_remote_state.network.outputs.network_id

  ingress {
    protocol          = "ANY"
    description       = "Взаимодействие мастер-узел и узел-узел внутри группы безопасности"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Взаимодействие под-под и сервис-сервис"
    v4_cidr_blocks = data.terraform_remote_state.network.outputs.v4_cidr_blocks
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "Отладочные ICMP-пакеты из внутренних подсетей"
    v4_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Весь исходящий трафик (Container Registry, Object Storage, Docker Hub и т.д.)"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_master" {
  name        = "${local.prefix}-k8s-master-sg"
  description = "Правила для мастер-узла кластера Kubernetes"
  network_id  = data.terraform_remote_state.network.outputs.network_id

  ingress {
    protocol       = "TCP"
    description    = "Доступ к API-серверу Kubernetes (kubectl)"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}

resource "yandex_vpc_security_group" "k8s_nodes" {
  name        = "${local.prefix}-k8s-nodes-sg"
  description = "Правила для рабочих узлов кластера Kubernetes"
  network_id  = data.terraform_remote_state.network.outputs.network_id

  ingress {
    protocol          = "TCP"
    description       = "Проверки доступности балансировщика нагрузки"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "Диапазон портов NodePort — NLB перенаправляет HTTP/HTTPS трафик через NGINX Ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}
