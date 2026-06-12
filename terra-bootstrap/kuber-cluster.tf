data "yandex_iam_service_account" "sa" {
  name = var.sa_name
}

resource "yandex_kubernetes_cluster" "regional_cluster" {
  name        = "netology-k8s"

  network_id = yandex_vpc_network.netology.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = "ru-central1-a"
        subnet_id = yandex_vpc_subnet.private-subnet-0.id
      }

      location {
        zone      = "ru-central1-b"
        subnet_id = yandex_vpc_subnet.private-subnet-1.id
      }

      location {
        zone      = "ru-central1-d"
        subnet_id = yandex_vpc_subnet.private-subnet-2.id
      }
    }

    version   = "1.32"
    public_ip = true

    master_logging {
      enabled                    = true
      folder_id                  = var.folder_id
      kube_apiserver_enabled     = true
      cluster_autoscaler_enabled = true
      events_enabled             = true
      audit_enabled              = true
    }

    scale_policy {
      auto_scale {
        min_resource_preset_id = "s-c4-m16"
      }
    }
  }

  service_account_id      = data.yandex_iam_service_account.sa.id
  node_service_account_id = data.yandex_iam_service_account.sa.id

  release_channel = "STABLE"

  workload_identity_federation {
    enabled = true
  }
}

# node group

resource "yandex_kubernetes_node_group" "node_group" {
  cluster_id  = yandex_kubernetes_cluster.regional_cluster.id
  name        = "netology-k8s-node"
  description = "description"
  version     = "1.32"

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = false
      subnet_ids = ["${yandex_vpc_subnet.private-subnet-0.id}", "${yandex_vpc_subnet.private-subnet-1.id}", "${yandex_vpc_subnet.private-subnet-2.id}"]
    }

    resources {
      core_fraction = 20
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
        zone      = "ru-central1-a"
      }

      location {
        zone      = "ru-central1-b"
      }

      location {
        zone      = "ru-central1-d"
      }
  }

  workload_identity_federation {
    enabled = true
  }
}

# kubeconfig

data "yandex_client_config" "client" {}

data "yandex_kubernetes_cluster" "regional_cluster" {
  name = "netology-k8s"
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content  = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(yandex_kubernetes_cluster.regional_cluster.master[0].cluster_ca_certificate)}
    server: ${yandex_kubernetes_cluster.regional_cluster.master[0].external_v4_endpoint}
  name: yc-k8s-cluster
contexts:
- context:
    cluster: yc-k8s-cluster
    user: yc-user
  name: yc-k8s-context
current-context: yc-k8s-context
kind: Config
preferences: {}
users:
- name: yc-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: yc
      args:
      - managed-kubernetes
      - cluster
      - get-credentials
      - --id
      - ${yandex_kubernetes_cluster.regional_cluster.id}
      - --external
      - --format
      - json
EOF
}