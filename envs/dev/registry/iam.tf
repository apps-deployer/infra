resource "yandex_iam_service_account" "registry_pusher" {
  name        = "${local.prefix}-registry-pusher-sa"
  description = "Сервисный аккаунт для публикации образов в Container Registry (используется build-воркером)"
}

resource "yandex_container_registry_iam_binding" "pusher_user_apps" {
  registry_id = yandex_container_registry.user_apps.id
  role        = "container-registry.images.pusher"
  members      = ["serviceAccount:${yandex_iam_service_account.registry_pusher.id}"]
}

resource "yandex_iam_service_account_static_access_key" "registry_pusher" {
  service_account_id = yandex_iam_service_account.registry_pusher.id
  description        = "Статический ключ для docker login в Yandex Container Registry"
}

resource "yandex_iam_service_account" "ci_pusher" {
  name        = "${local.prefix}-ci-pusher-sa"
  description = "Сервисный аккаунт для публикации образов платформенных сервисов из CI/CD пайплайна"
}

resource "yandex_container_registry_iam_binding" "ci_pusher_main" {
  registry_id = yandex_container_registry.main.id
  role        = "container-registry.images.pusher"
  members      = ["serviceAccount:${yandex_iam_service_account.ci_pusher.id}"]
}

resource "yandex_iam_service_account_static_access_key" "ci_pusher" {
  service_account_id = yandex_iam_service_account.ci_pusher.id
  description        = "Статический ключ для docker login в CI/CD пайплайне"
}

resource "yandex_iam_service_account" "lifecycle_manager" {
  name        = "${local.prefix}-lifecycle-manager-sa"
  description = "Сервисный аккаунт для управления политиками жизненного цикла образов (CronJob)"
}

resource "yandex_container_registry_iam_binding" "lifecycle_manager_editor" {
  registry_id = yandex_container_registry.user_apps.id
  role        = "container-registry.editor"
  members      = ["serviceAccount:${yandex_iam_service_account.lifecycle_manager.id}"]
}

resource "yandex_iam_service_account_static_access_key" "lifecycle_manager" {
  service_account_id = yandex_iam_service_account.lifecycle_manager.id
  description        = "Статический ключ для CronJob управления политиками жизненного цикла"
}
