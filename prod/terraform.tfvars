region = "ap-south-1"

key_name = "ATL-RnA-Athena-Ec2"

common_tags = {
  project     = "athena2.0"
  owner       = "shailender.gupta@apollotyres.com"
  environment = "prod"
}

security_groups = {

  EC2-SG = {
    name        = "ATL-APAC-MUM-DTLK-PROD-ATHENA2.0-EC2-01-SG"
    description = "ATL-APAC-MUM-DTLK-PROD-ATHENA2.0-EC2-01 security Group"
    vpc_id      = "vpc-0d998ab18a806df39"

    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    tags = {
      project         = "athena2.0"
      owner           = "shailender.gupta@apollotyres.com"
      os              = "al2023"
      source_creation = "terraform"
      Criticality     = "AAA"
      environment     = "prod"
    }
  }
}

#######################
###EC2 Repo
#######################

ec2_instances = {

  EC2-01 = {
    name               = "ATL-APAC-MUM-DTLK-PROD-ATHENA2.0-EC2-01"
    ami                = "ami-0f559c3642608c138"
    instance_type      = "t2.medium"
    subnet_id          = "subnet-0307ac50da362607f"
    key_name           = "ATL-RnA-Athena-Ec2"
    security_group_key = "EC2-SG"
    volume_size        = 100

    tags = {
      project         = "athena2.0"
      owner           = "shailender.gupta@apollotyres.com"
      os              = "al2023"
      source_creation = "terraform"
      Criticality     = "AAA"
      environment     = "prod"
    }
  }

  # EC2-02 = {
  #   name               = "ATL-APAC-MUM-DTLK-PROD-ATHENA2.0-EC2-02"
  #   ami                = "ami-0d44b036bd2b73294"
  #   instance_type      = "r6g.large"
  #   subnet_id          = "subnet-049a7c795c20c781d"
  #   key_name           = "ATL-RnA-Athena-Ec2"
  #   security_group_key = "EC2-SG"
  #   volume_size        = 100

  #   tags = {
  #     project         = "athena2.0"
  #     owner           = "shailender.gupta@apollotyres.com"
  #     os              = "al2023"
  #     source_creation = "terraform"
  #     Criticality     = "AAA"
  #     environment     = "prod"
  #   }
  # }
}



#######################
#ECR Repo
#######################

ecr_repositories = {
  Ecr-01 = {
    repository_name = "atl_apac_mum_dtlk_prod_athena2.0_ecr_01"
    tag_mutability  = "MUTABLE"
    scan_on_push    = true

    tags = {
      project         = "athena2.0"
      owner           = "shailender.gupta@apollotyres.com"
      os              = "al2023"
      source_creation = "terraform"
      Criticality     = "AAA"
      environment     = "prod"
    }
  }
}
#########################
#KMS Key
#########################
alias_name = "athena-ebs-key"
description = "Encryption key for EBS volumes"
deletion_window_in_days = 7
