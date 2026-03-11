variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}

variable "security_groups" {}

variable "tags" {
  type = map(string)
}

variable "volume_size" {
  description = "Root volume size for EC2"
  type        = number
  default     = 100
}
variable "kms_key_arn" {
  description = "The ARN of the KMS CMK to use for EBS encryption"
  type        = string
}
