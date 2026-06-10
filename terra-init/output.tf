output "bucket_name" {
  value = yandex_storage_bucket.state_bucket.bucket
}

output "sa-name" {
  value = yandex_iam_service_account.sa.name
}

output "service_account_key_json" {
  description = "The JSON key for the Service Account"
  value = jsonencode({
    id                 = yandex_iam_service_account_key.sa_auth_key.id
    service_account_id = yandex_iam_service_account_key.sa_auth_key.service_account_id
    created_at         = yandex_iam_service_account_key.sa_auth_key.created_at
    key_algorithm      = yandex_iam_service_account_key.sa_auth_key.key_algorithm
    public_key         = yandex_iam_service_account_key.sa_auth_key.public_key
    private_key        = yandex_iam_service_account_key.sa_auth_key.private_key
  })
  sensitive = true
}

output "service_account_static_key_json" {
  description = "The JSON key S3 for the Service Account"
  value = jsonencode({
    access_key             = yandex_iam_service_account_static_access_key.sa_static_key.access_key
    secret_key         = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  })
  sensitive = true
}