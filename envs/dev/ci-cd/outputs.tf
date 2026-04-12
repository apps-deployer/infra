output "ci_infra_sa_key" {
  description = "JSON-ключ SA для infra-k8s репозитория (YC_SA_KEY)"
  sensitive   = true
  value = jsonencode({
    id                 = yandex_iam_service_account_key.ci_infra.id
    service_account_id = yandex_iam_service_account_key.ci_infra.service_account_id
    created_at         = yandex_iam_service_account_key.ci_infra.created_at
    key_algorithm      = yandex_iam_service_account_key.ci_infra.key_algorithm
    public_key         = yandex_iam_service_account_key.ci_infra.public_key
    private_key        = yandex_iam_service_account_key.ci_infra.private_key
  })
}

output "ci_apps_sa_key" {
  description = "JSON-ключ SA для репозиториев сервисов (YC_SA_KEY)"
  sensitive   = true
  value = jsonencode({
    id                 = yandex_iam_service_account_key.ci_apps.id
    service_account_id = yandex_iam_service_account_key.ci_apps.service_account_id
    created_at         = yandex_iam_service_account_key.ci_apps.created_at
    key_algorithm      = yandex_iam_service_account_key.ci_apps.key_algorithm
    public_key         = yandex_iam_service_account_key.ci_apps.public_key
    private_key        = yandex_iam_service_account_key.ci_apps.private_key
  })
}
