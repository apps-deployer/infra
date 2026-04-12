# SA для infra-k8s репозитория: полный доступ к кластеру
resource "yandex_iam_service_account" "ci_infra" {
  name        = "${local.prefix}-ci-infra-sa"
  description = "CI/CD для инфраструктурного репозитория (helmfile, манифесты)"
}

resource "yandex_resourcemanager_folder_iam_member" "ci_infra_k8s_viewer" {
  folder_id = var.folder_id
  role      = "k8s.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.ci_infra.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "ci_infra_cluster_admin" {
  folder_id = var.folder_id
  role      = "k8s.cluster-api.cluster-admin"
  member    = "serviceAccount:${yandex_iam_service_account.ci_infra.id}"
}

resource "yandex_iam_service_account_key" "ci_infra" {
  service_account_id = yandex_iam_service_account.ci_infra.id
  description        = "Ключ для CI/CD инфраструктурного репозитория"
}

# SA для репозиториев сервисов: деплой в apps-deployer + пуш образов
resource "yandex_iam_service_account" "ci_apps" {
  name        = "${local.prefix}-ci-apps-sa"
  description = "CI/CD для репозиториев сервисов (helm upgrade, docker push)"
}

resource "yandex_resourcemanager_folder_iam_member" "ci_apps_k8s_viewer" {
  folder_id = var.folder_id
  role      = "k8s.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.ci_apps.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "ci_apps_k8s_editor" {
  folder_id = var.folder_id
  role      = "k8s.cluster-api.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ci_apps.id}"
}

resource "yandex_container_registry_iam_binding" "ci_apps_pusher" {
  registry_id = data.terraform_remote_state.registry.outputs.registry_id
  role        = "container-registry.images.pusher"
  members     = ["serviceAccount:${yandex_iam_service_account.ci_apps.id}"]
}

resource "yandex_iam_service_account_key" "ci_apps" {
  service_account_id = yandex_iam_service_account.ci_apps.id
  description        = "Ключ для CI/CD репозиториев сервисов"
}
