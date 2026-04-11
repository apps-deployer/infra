resource "yandex_kubernetes_cluster" "main" {
  name        = "${local.prefix}-k8s"
  description = "Основной кластер Kubernetes"
  network_id  = data.terraform_remote_state.network.outputs.network_id
  master {
    version   = "1.30"
    public_ip = true
    master_location {
      zone      = var.zone
      subnet_id = data.terraform_remote_state.network.outputs.subnet_id
    }
    security_group_ids = [
      yandex_vpc_security_group.k8s_common.id,
      yandex_vpc_security_group.k8s_master.id,
    ]
    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        day        = "monday"
        start_time = "10:00"
        duration   = "9h"
      }
      maintenance_window {
        day        = "tuesday"
        start_time = "10:00"
        duration   = "9h"
      }
      maintenance_window {
        day        = "wednesday"
        start_time = "10:00"
        duration   = "9h"
      }
      maintenance_window {
        day        = "thursday"
        start_time = "10:00"
        duration   = "9h"
      }
      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "9h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8s.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_clusters_agent,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.images_puller,
    yandex_resourcemanager_folder_iam_member.encrypter_decrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s.id
  }
}

resource "yandex_kubernetes_node_group" "main" {
  cluster_id  = yandex_kubernetes_cluster.main.id
  name        = "${local.prefix}-k8s-ng"
  description = "Группа рабочих узлов"
  version     = "1.30"
  instance_template {
    name        = "{instance.short_id}-{instance_group.id}"
    platform_id = "standard-v3"
    network_interface {
      subnet_ids = [data.terraform_remote_state.network.outputs.subnet_id]
      security_group_ids = [
        yandex_vpc_security_group.k8s_common.id,
        yandex_vpc_security_group.k8s_nodes.id,
      ]
      nat = true
    }
    resources {
      memory = 6
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = true
    }
    container_runtime {
      type = "containerd"
    }
  }

  fixed_scale {
    size = 2
  }

  deploy_policy {
    max_expansion   = 1
    max_unavailable = 1
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "10:00"
      duration   = "9h"
    }
    maintenance_window {
      day        = "tuesday"
      start_time = "10:00"
      duration   = "9h"
    }
    maintenance_window {
      day        = "wednesday"
      start_time = "10:00"
      duration   = "9h"
    }
    maintenance_window {
      day        = "thursday"
      start_time = "10:00"
      duration   = "9h"
    }
    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "9h"
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }
}
