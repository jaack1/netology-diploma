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
          image = "nginx:1.30.2"
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
resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }
  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.web_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}