resource "aws_instance" "ec2" {

  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  associate_public_ip_address = false

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"

    encrypted   = true
    kms_key_id  = var.kms_key_arn
  }
  user_data_base64 = filebase64("${path.module}/userdata.sh")

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}


# 1. Create the IAM Role
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Attach the AWS-managed SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. Create the Instance Profile (this is the actual "container" for the role)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
