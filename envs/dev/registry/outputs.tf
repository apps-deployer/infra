# Internal registry (platform services)
output "registry_id" {
  value = yandex_container_registry.main.id
}

output "registry_endpoint" {
  value = "cr.yandex/${yandex_container_registry.main.id}"
}

# User apps registry
output "user_apps_registry_id" {
  value = yandex_container_registry.user_apps.id
}

output "user_apps_registry_endpoint" {
  value = "cr.yandex/${yandex_container_registry.user_apps.id}"
}

# Build worker credentials (push to user-apps registry)
output "pusher_sa_id" {
  value = yandex_iam_service_account.registry_pusher.id
}

output "pusher_sa_key" {
  description = "JSON-ключ registry-pusher-sa для сохранения в REGISTRY_PUSHER_KEY (GitHub Actions secret)"
  sensitive   = true
  value = jsonencode({
    id                 = yandex_iam_service_account_key.registry_pusher.id
    service_account_id = yandex_iam_service_account_key.registry_pusher.service_account_id
    created_at         = yandex_iam_service_account_key.registry_pusher.created_at
    key_algorithm      = yandex_iam_service_account_key.registry_pusher.key_algorithm
    public_key         = yandex_iam_service_account_key.registry_pusher.public_key
    private_key        = yandex_iam_service_account_key.registry_pusher.private_key
  })
}

# Lifecycle manager credentials (CronJob)
output "lifecycle_manager_sa_id" {
  value = yandex_iam_service_account.lifecycle_manager.id
}

output "lifecycle_manager_access_key_id" {
  value     = yandex_iam_service_account_static_access_key.lifecycle_manager.access_key
  sensitive = true
}

output "lifecycle_manager_secret_key" {
  value     = yandex_iam_service_account_static_access_key.lifecycle_manager.secret_key
  sensitive = true
}
