resource "aws_security_group" "worker_group" {
  name   = "${var.prefix}-${var.project}-${var.env}-sg-eucentral1-workergroup"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.prefix}-${var.project}-${var.env}-eks"
  cluster_version = "1.20"
  version         = "17.1.0"
  subnets         = var.subnet_id

  tags = {
    Environment = "${var.env}"
  }

  vpc_id = var.vpc_id

  node_groups_defaults = {
    disk_size = 8
    disk_type = "gp2"
  }
  node_groups = [
    {
      instance_types            = ["t3.large"]
      max_capacity              = 10
      min_capacity              = 1
      desired_capacity          = 1
      source_security_group_ids = [aws_security_group.worker_group.id]
    }
  ]
}



data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.20-v*"]
  }

  most_recent = true

  owners = ["amazon"]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
