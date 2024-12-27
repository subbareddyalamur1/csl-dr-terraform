locals {
  vpc_cidr = local.inputs.vpc_cidr_block  # Replace with your VPC CIDR
}

# CDR Security Group
module "cdr_sg" {
  source = "../42/modules/security_group"

  name        = "${local.inputs.servers.cdr.name}-sg"
  description = "Security group for CDR server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from NLB"
      from_port   = 443
      to_port     = 443
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

  tags = local.inputs.tags
}

# SFTP Security Group
module "sftp_sg" {
  source = "../42/modules/security_group"

  name        = "${local.inputs.servers.sftp.name}-sg"
  description = "Security group for SFTP server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "SSH from NLB"
      from_port   = 22
      to_port     = 22
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

  tags = local.inputs.tags
}

# SAS Security Group
module "sas_sg" {
  source = "../42/modules/security_group"

  name        = "${local.inputs.servers.sas.name}-sg"
  description = "Security group for SAS server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from ALB"
      from_port   = 443
      to_port     = 443
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

  tags = local.inputs.tags
}

