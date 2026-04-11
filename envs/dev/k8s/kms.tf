resource "yandex_kms_symmetric_key" "k8s" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "${local.prefix}-kms"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}
