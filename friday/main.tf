resource "kubernetes_config_map" "index_friday" {
  metadata {
    name = "friday-index"
  }

  data = {
    "index.html" = file("${path.module}/index.html")
  }
}

resource "kubernetes_service" "nginx_friday" {
  metadata {
    name = "nginx-friday"

    labels = {
      name = "nginx-friday"
    }
  }

  spec {
    port {
      name        = "nginx-friday-port"
      protocol    = "TCP"
      port        = 8080
      target_port = 80
    }

    selector = {
      app = "nginx-friday"
    }
  }
}

resource "kubernetes_pod" "nginx_friday" {
  metadata {
    name = "nginx-friday"
  }

  spec {
    volume {
      name = "index"

      config_map {
        name = "friday-index"
      }
    }

    container {
      name  = "nginx-friday"
      image = "nginx@sha256:fcce3ef4eaa65b0e0984e6d59759f8c978edb4f83061c8f194f01010306ce64e"

      port {
        container_port = 80
      }

      volume_mount {
        name       = "index"
        mount_path = "/usr/share/nginx/html"
      }
    }
  }
}
