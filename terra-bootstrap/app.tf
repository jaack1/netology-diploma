# 1. Sample Backend Deployment
resource "kubernetes_deployment_v1" "web_app" {
  metadata {
    name = "web-app-deployment"
    labels = { app = "web-app" }
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "web-app" } }
    template {
      metadata { labels = { app = "web-app" } }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port { container_port = 80 }
        }
      }
    }
  }
  depends_on = [yandex_kubernetes_node_group.node_group]
}

# 2. Target Service
resource "kubernetes_service_v1" "web_service" {
  metadata {
    name = "web-service"
  }
  spec {
    selector = { app = "web-app" }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort" # Mandatory for Yandex ALB integration
  }
}

# 3. Yandex Cloud Ingress Declaration
resource "kubernetes_ingress_v1" "yc_ingress" {
  metadata {
    name = "yc-alb-ingress"
    annotations = {
      # Instantiates an external Yandex Application Load Balancer automatically
      "yandex.cloud/ingress-class" = "yc-alb"
      "ingress.alb.yc.io/external-ipv4-address" = "auto"
    }
  }
  spec {
    rule {
#      host = yandex_kubernetes_cluster.regional_cluster.master[0].external_v4_endpoint
      http {
        path {
          path = "/my-app"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.web_service.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}