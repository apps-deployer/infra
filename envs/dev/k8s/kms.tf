resource "yandex_kms_symmetric_key" "k8s" {
  name              = "${local.prefix}-kms"
  description       = "Ключ шифрования секретов кластера Kubernetes (пароли, токены, SSH-ключи)"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год
}
