terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.12.0"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "hsjack-terraform-state"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}

provider "yandex" {
  service_account_key_file     = var.key_file
  cloud_id                     = var.cloud_id
  folder_id                    = var.folder_id
  zone                         = var.default_zone
}

provider "kubernetes" {
  host                   = yandex_kubernetes_cluster.regional_cluster.master[0].external_v4_endpoint
  cluster_ca_certificate = yandex_kubernetes_cluster.regional_cluster.master[0].cluster_ca_certificate
  token                  = data.yandex_client_config.client.iam_token
}