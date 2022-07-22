
resource "kubernetes_deployment" "petclinic" {
  metadata {
    name = "petclinic"
    labels = {
      App = "petclinic"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "petclinic"
      }
    }
    template {
      metadata {
        labels = {
          App = "petclinic"
        }
      }
      spec {
        container {
          image = "springcommunity/spring-framework-petclinic:5.3.0"
          name  = "petclinic"

          port {
            container_port = 8080
          }

        }
      }
    }
  }
}


resource "kubernetes_service" "petclinic" {
  metadata {
    name = "petclinic"
  }
  spec {
    selector = {
      App = kubernetes_deployment.petclinics.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
