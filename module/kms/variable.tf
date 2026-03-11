variable "description" { 
default = "KMS Key for EBS Encryption"
}

variable "deletion_window_in_days" { 
default = 7 
}
variable "alias_name" { 
default = "ebs-key" 
}
variable "region" { 
type = string 
default = "ap-south-1" 
}