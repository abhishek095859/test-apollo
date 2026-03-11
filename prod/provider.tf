provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "athena-apollotyres-test"
    key    = "infra"
    region = "ap-south-1"
        assume_role = {
      role_arn = "arn:aws:iam::602151476946:role/CrossAccountStateRole"
    }
  }
}

