variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "project" {
  type    = string
  default = "apps-deployer"
}

variable "env" {
  type = string
}

variable "domain_zone" {
  type        = string
  description = "DNS zone"
}

locals {
  prefix = "${var.project}-${var.env}"
}
