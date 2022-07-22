
terraform {
 backend "s3" {
    bucket = "sahana-assessment-terraform-state"
    key    = "dev/terraform-state"
    region = "eu-central-1"
  }
}
