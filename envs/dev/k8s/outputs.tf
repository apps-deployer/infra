output "k8s_cluster_id" {
  value = yandex_kubernetes_cluster.main.id
}

output "k8s_cluster_endpoint" {
  value = yandex_kubernetes_cluster.main.master[0].external_v4_endpoint
}

output "ingress_external_ip" {
  value = data.terraform_remote_state.network.outputs.ingress_external_ip
}
