locals {
  vpc_cidr = "10.0.0.0/16"  # Replace with your VPC CIDR
}

# CDR Security Group
module "cdr_sg" {
  source = "../42/modules/security_group"

  name        = "cdr-sg"
  description = "Security group for CDR server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from NLB"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
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

  name        = "sftp-sg"
  description = "Security group for SFTP server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "SSH from NLB"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
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

  name        = "sas-sg"
  description = "Security group for SAS server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from ALB"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      security_groups = [module.sas_alb_sg.security_group_id]
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

# GUAC Security Group
module "guac_sg" {
  source = "../42/modules/security_group"

  name        = "guac-sg"
  description = "Security group for GUAC server"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from ALB"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      security_groups = [module.guac_alb_sg.security_group_id]
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

# SAS ALB Security Group
module "sas_alb_sg" {
  source = "../42/modules/security_group"

  name        = "sas-alb-sg"
  description = "Security group for SAS ALB"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from anywhere"
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

# GUAC ALB Security Group
module "guac_alb_sg" {
  source = "../42/modules/security_group"

  name        = "guac-alb-sg"
  description = "Security group for GUAC ALB"
  vpc_id      = local.inputs.vpc_id

  ingress_rules = [
    {
      description = "HTTPS from anywhere"
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