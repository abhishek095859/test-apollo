provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "athena-apollotyres-test"
    key    = "infra"
    region = "ap-south-1"
  }
}

