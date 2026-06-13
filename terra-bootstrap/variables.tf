###cloud vars
variable "key_file" {
  type        = string
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "sa_name" {
  type = string
  default = "netology-deploy"
}

### VPC

variable "default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnet_count" {
  type        = string
  default     = "3"
  description = "Count of subnets"
}

variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network&subnet name"
}

variable "public_subnet_name" {
  type        = string
  default     = "public-subnet"
  description = "VPC public subnet name"
}

variable "private_subnet_name" {
  type        = string
  default     = "private-subnet"
  description = "VPC private subnet name"
}

variable "sg_nat_name" {
  type        = string
  default     = "nat-instance-sg"
  description = "NAT security group name"
}

### S3

variable "bucket_name" {
  type        = string
  default = "netology-bucket-tralala"
}

variable "key_name" {
  type        = string
  default = "bucket-key"
}

variable "key_desc" {
  type        = string
  default = "Bucket encryption key"
}

### VMs

variable "vm_user" {
  type = string
  default = "jack"
}

variable "ssh_key_path" {
  type = string
  default = "id_ed25519.pub"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform id"
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS Family"
}

variable "vm_test_name" {
  type = string
  default = "test-vm"
}

variable "vm_nat_name" {
  type = string
  default = "nat-instance"
}

variable "route_table_name" {
  type = string
  default = "nat-instance-route"
}
