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

output "pusher_access_key_id" {
  value     = yandex_iam_service_account_static_access_key.registry_pusher.access_key
  sensitive = true
}

output "pusher_secret_key" {
  value     = yandex_iam_service_account_static_access_key.registry_pusher.secret_key
  sensitive = true
}

# CI/CD pipeline credentials (push to main registry)
output "ci_pusher_sa_id" {
  value = yandex_iam_service_account.ci_pusher.id
}

output "ci_pusher_access_key_id" {
  value     = yandex_iam_service_account_static_access_key.ci_pusher.access_key
  sensitive = true
}

output "ci_pusher_secret_key" {
  value     = yandex_iam_service_account_static_access_key.ci_pusher.secret_key
  sensitive = true
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
