resource "yandex_iam_service_account" "sa" {
  name        = "netology-deploy"
  description = "Сервисный аккаунт для управления инфраструктурой"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa_role" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Авторизованный ключ
resource "yandex_iam_service_account_key" "sa_auth_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Авторизованный ключ для SA"
  key_algorithm      = "RSA_2048"
}

# Статический ключ доступа (для работы с Object Storage/S3)
resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Статический ключ для S3"
}