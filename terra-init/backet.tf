resource "yandex_storage_bucket" "state_bucket" {
  bucket     = "hsjack-terraform-state"
  folder_id  = var.folder_id
  max_size   = 1073741824
  
  # Политика версионности
  versioning {
    enabled = true
  }
}