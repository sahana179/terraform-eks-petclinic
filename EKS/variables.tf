variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "prefix" {
  default = "ss"
}

variable "project" {
  default = "asignment"
}

variable "env" {
  default = "dev"
}


variable "vpc_id" {

  default = "vpc-0f8f8e6d696058c1b"
}

variable "subnet_id" {

  default = ["subnet-0098be9fcd50c99a3", "subnet-048343432d7ed8716"]
}