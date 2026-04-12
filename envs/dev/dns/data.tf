data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "apps-deployer-tfstate"
    key    = "dev/network/terraform.tfstate"
    region = "ru-central1"

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
