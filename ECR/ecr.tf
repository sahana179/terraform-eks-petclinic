resource "aws_ecr_repository" "springapp" {
  name                 = "${var.prefix}-${var.project}-${var.env}-ecr-eucentral1-springapp"
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = "${var.env}"
  }
}