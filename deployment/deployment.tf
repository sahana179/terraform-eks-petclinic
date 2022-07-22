##########################################################
########## DATA SOURCE FOR ECR ###########################
##########################################################

data "terraform_remote_state" "ecr" {
  backend = "s3"
    config = {
        bucket  = "sahana-assessment-terraform-state"
        key     = "dev/terraform-state"
        region  = var.aws_region
    }
}

##########################################################
########## LOCAL VARIABLES ###############################
##########################################################

locals {
  registry_server = "https://${data.terraform_remote_state.ecr.outputs.ecr_registry_id}.dkr.ecr.us-west-2.amazonaws.com"
  image_name = "${data.terraform_remote_state.ecr.outputs.ecr_repository_url}:${var.docker_build_tag}"  
}

##########################################################
########## SECRET FOR DOCKER ###############################
##########################################################

resource "kubernetes_secret" "docker" {
  metadata {
    name = "secret-ecrregistry"
  }
  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${local.registry_server}": {
      "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

##########################################################
########## K8's Deployment ###############################
##########################################################

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
        image_pull_secrets {
          name = "secret-ecrregistry"
        } 
        container {
          image = local.image_name
          name  = "petclinic"

          port {
            container_port = 8080
          }

        }
      }
    }
  }
}

##########################################################
########## K8's Service ###############################
##########################################################

resource "kubernetes_service" "petclinic" {
  metadata {
    name = "petclinic"
  }
  spec {
    selector = {
      App = kubernetes_deployment.petclinic.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
