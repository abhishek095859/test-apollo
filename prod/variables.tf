

variable "region" {}

variable "security_groups" {}
variable "ec2_instances" {}
variable "key_name" { type = string }
variable "common_tags" { type = map(string) }

variable "ecr_repositories" {
  description = "Map of ECR repositories"
  type = map(object({
    repository_name      = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}
variable "alias_name" {
  type        = string
  description = "The display name for the KMS key"
}

variable "description" {
  type        = string
  description = "The description for the KMS key"
}

# variable "deletion_window_in_days" {
#   type        = number
#   description = "Days to wait before deleting the key"
# }
# variable "crowdstrike_installer_s3" {
#   type = string
# }
 
# variable "crowdstrike_cid" {
#   type = string
# }
variable "vpc_id" {
  description = "The ID of the existing VPC to import"
  type        = string
  #default     = "vpc-0d998ab18a806df39"
}

variable "subnet_id" {
  description = "The ID of the existing subnet to import"
  type        = string
  #default     = "subnet-078481691ca6901e4"
}
