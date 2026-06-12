resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = var.public_subnet_name
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-0" {
  name           = "private-subnet-0"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "private-subnet-1" {
  name           = "private-subnet-1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.21.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "private-subnet-2" {
  name           = "private-subnet-2"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.22.0/24"]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "nat-instance-route"
  network_id = yandex_vpc_network.netology.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = var.sg_nat_name
  network_id = yandex_vpc_network.netology.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}
