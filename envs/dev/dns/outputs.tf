output "dns_solver_sa_key" {
  value = jsonencode({
    id                 = yandex_iam_service_account_key.dns_solver.id
    service_account_id = yandex_iam_service_account.dns_solver.id
    private_key        = yandex_iam_service_account_key.dns_solver.private_key
  })
  sensitive = true
}
