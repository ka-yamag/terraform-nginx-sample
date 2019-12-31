resource "kubernetes_config_map" "index_maria" {
  metadata {
    name = "maria-index"
  }

  data = {
    "index.html" = file("${path.module}/index.html")
  }
}

resource "kubernetes_service" "nginx_maria" {
  metadata {
    name = "nginx-maria"

    labels = {
      name = "nginx-maria"
    }
  }

  spec {
    port {
      name        = "nginx-maria-port"
      protocol    = "TCP"
      port        = 8090
      target_port = 80
    }

    selector = {
      app = "nginx-maria"
    }
  }
}

resource "kubernetes_pod" "nginx_maria" {
  metadata {
    name = "nginx-maria"
  }

  spec {
    volume {
      name = "index"

      config_map {
        name = "maria-index"
      }
    }

    container {
      name  = "nginx-maria"
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
