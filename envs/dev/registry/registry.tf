resource "yandex_container_registry" "main" {
  name      = "${local.prefix}-registry"
  folder_id = var.folder_id
}

resource "yandex_container_registry" "user_apps" {
  name      = "${local.prefix}-user-apps-registry"
  folder_id = var.folder_id
}
