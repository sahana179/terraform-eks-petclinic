output "ecr_arn" {
  value = aws_ecr_repository.springapp.arn
}
output "ecr_repository_url" {
  value = aws_ecr_repository.springapp.repository_url
}
output "ecr_registry_id" {
  value = aws_ecr_repository.springapp.registry_id
}
