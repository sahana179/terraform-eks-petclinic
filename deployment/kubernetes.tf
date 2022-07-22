data "terraform_remote_state" "cluster" {
  backend = "s3"
    config = {
        bucket  = "sahana-assessment-terraform-state"
        key     = "dev/eks/terraform-state"
        region  = var.aws_region
    }
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.cluster.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = data.terraform_remote_state.cluster.outputs.cluster_ca_certificate
}



