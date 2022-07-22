variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "registry_username" {
  default = "AWS" 
}

variable "registry_password" {
  
}

variable "docker_build_tag" {
  default = "latest" 
}