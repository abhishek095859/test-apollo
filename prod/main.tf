
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}
 
data "aws_subnet" "existing_subnet" {
  id = var.subnet_id
}


# Security Group

module "security_groups" {

  source = "../module/security_group"

  for_each = var.security_groups

  name          = each.value.name
  description   = each.value.description
  vpc_id        = data.aws_vpc.existing_vpc.id
  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules
  tags          = each.value.tags
}


# EC2 Instances

module "ec2_instances" {
  source        = "../module/ec2"
  for_each      = var.ec2_instances
  name          = each.value.name
  ami           = each.value.ami
  instance_type = each.value.instance_type
  vpc_id        = data.aws_vpc.existing_vpc.id
  subnet_id     = data.aws_subnet.existing_subnet.id
  key_name      = var.key_name
  security_groups = [
    module.security_groups[each.value.security_group_key].security_group_id
  ]
  volume_size = each.value.volume_size
  tags        = each.value.tags
  kms_key_arn  = module.kms.key_arn
  # crowdstrike_installer_s3 = var.crowdstrike_installer_s3
  # crowdstrike_cid          = var.crowdstrike_cid
}

#ECR Repositories

module "ecr" {
  source = "../module/ecr"

  for_each = var.ecr_repositories

  repository_name      = each.value.repository_name
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = each.value.scan_on_push
  tags                 = each.value.tags
}


# module "key_pair" {
#   source   = "../module/key_pair"
#   key_name = var.key_name
#   tags     = var.common_tags
# }
module "kms" {
  source = "../module/kms"
  region = var.region
  alias_name              = var.alias_name
  description             = var.description
  #deletion_window_in_days = var.deletion_window_in_days
}
