resource "yandex_iam_service_account" "dns_solver" {
  name        = "${local.prefix}-dns-solver"
  description = "For cert-manager DNS-01 challenge via Yandex Cloud DNS"
}

resource "yandex_resourcemanager_folder_iam_member" "dns_solver_editor" {
  folder_id = var.folder_id
  role      = "dns.editor"
  member    = "serviceAccount:${yandex_iam_service_account.dns_solver.id}"
}

resource "yandex_iam_service_account_key" "dns_solver" {
  service_account_id = yandex_iam_service_account.dns_solver.id
  description        = "Key for cert-manager DNS-01 solver"
}
