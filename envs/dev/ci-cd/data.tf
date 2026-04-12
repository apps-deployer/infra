data "terraform_remote_state" "registry" {
  backend = "s3"
  config = {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "apps-deployer-tfstate"
    region = "ru-central1"
    key    = "dev/registry/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
