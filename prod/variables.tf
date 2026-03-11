# variable "region" {}

# variable "security_groups" {}

# variable "ec2_instances" {
#   type = map(object({
#     name            = string
#     ami             = string
#     instance_type   = string
#     subnet_id       = string
#     key_name        = string
#     security_groups = list(string)
#     tags            = map(string)
#   }))
# }

# variable "ecr_repositories" {
#   # type = map(object({
#   #   name           = string
#   #   tag_mutability = string
#   #   scan_on_push   = bool
#   #   tags           = map(string)
#   # }))
# }

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

variable "deletion_window_in_days" {
  type        = number
  description = "Days to wait before deleting the key"
}