resource "aws_instance" "ec2" {

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"

    encrypted   = true
    kms_key_id  = var.kms_key_arn
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# resource "aws_kms_key" "ec2_kms" {
#   description             = "KMS key for EC2 EBS encryption"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
# }

# # 2. This creates a readable Alias
# resource "aws_kms_alias" "ec2_kms_alias" {
#   name          = "alias/ec2-encryption-key"
#   target_key_id = aws_kms_key.ec2_kms.key_id
# }

# # 3. This creates your EC2 using that Key
# resource "aws_instance" "ec2" {
#   ami                    = var.ami
#   instance_type          = var.instance_type
#   subnet_id              = var.subnet_id
#   key_name               = var.key_name
#   vpc_security_group_ids = var.security_groups

#   root_block_device {
#     volume_size = var.volume_size
#     volume_type = "gp3"
#     encrypted   = true
#     kms_key_id  = aws_kms_key.ec2_kms.arn # Link to the resource above
#   }

#   tags = merge({ Name = var.name }, var.tags)
# }
