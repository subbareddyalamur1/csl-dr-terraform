
# SFTP Network Load Balancer
module "sftp_nlb" {
  source = "./modules/nlb"

  name               = "${local.inputs.servers.sftp.name}-nlb"
  internal           = false
  subnets           = local.inputs.servers.sftp.elb_subnets
  vpc_id            = local.inputs.vpc_id

  enable_cross_zone_load_balancing = true
  enable_access_logs              = false

  target_groups = [
    {
      name        = "${local.inputs.servers.sftp.name}-tg"
      port        = 22
      protocol    = "TCP"
      target_type = "instance"
      health_check = {
        enabled             = true
        protocol            = "TCP"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        interval            = 30
      }
    }
  ]

  listeners = [
    {
      port     = 22
      protocol = "TCP"
      default_action = {
        type             = "forward"
        target_group_key = 0
      }
    }
  ]

  tags = local.inputs.tags
}

# Application Load Balancer for CDR
module "cdr_alb" {
  source = "./modules/alb"

  name               = "${local.inputs.servers.cdr.name}-alb"
  internal           = false
  security_groups    = [module.cdr_alb_sg.security_group_id]
  subnets           = local.inputs.servers.cdr.elb_subnets
  vpc_id            = local.inputs.vpc_id

  enable_cross_zone_load_balancing = false
  idle_timeout                     = 1800
  enable_http2                     = true
  enable_access_logs               = false
  
  default_ssl_policy     = "ELBSecurityPolicy-2016-08"
  default_certificate_arn = local.inputs.alb_certificate_arn

  target_groups = [
    {
      name        = "${local.inputs.servers.cdr.name}-tg"
      port        = 443
      protocol    = "HTTPS"
      target_type = "instance"
      health_check = {
        enabled             = true
        protocol            = "HTTPS"
        path                = "/api/v1/health_checks"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    }
  ]

  listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-2016-08"
      certificate_arn = local.inputs.alb_certificate_arn
      default_action = {
        type             = "forward"
        target_group_key = 0
        redirect         = null
      }
    }
  ]

  tags = local.inputs.tags
}

# Application Load Balancer for SAS
module "sas_alb" {
  source = "./modules/alb"

  name               = "${local.inputs.servers.sas.name}-alb"
  internal           = false
  security_groups    = [module.sas_alb_sg.security_group_id]
  subnets           = local.inputs.servers.sas.elb_subnets
  vpc_id            = local.inputs.vpc_id

  enable_cross_zone_load_balancing = false
  idle_timeout                     = 1800
  enable_http2                     = true
  enable_access_logs               = false
  
  default_ssl_policy     = "ELBSecurityPolicy-2016-08"
  default_certificate_arn = local.inputs.alb_certificate_arn

  target_groups = [
    {
      name        = "${local.inputs.servers.sas.name}-tg"
      port        = 443
      protocol    = "HTTPS"
      target_type = "instance"
      health_check = {
        enabled             = true
        protocol            = "HTTPS"
        path                = "/"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    }
  ]

  listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-2016-08"
      certificate_arn = local.inputs.alb_certificate_arn
      default_action = {
        type             = "forward"
        target_group_key = 0
        redirect         = null
      }
    },
    {
      port            = 80
      protocol        = "HTTP"
      ssl_policy      = null
      certificate_arn = null
      default_action = {
        type             = "redirect"
        target_group_key = null
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
    }
  ]

  tags = local.inputs.tags
}

# Application Load Balancer for GUAC
module "guac_alb" {
  source = "./modules/alb"

  name               = "${local.inputs.servers.guac.name}-alb"
  internal           = false
  security_groups    = [module.guac_alb_sg.security_group_id]
  subnets           = local.inputs.servers.guac.elb_subnets
  vpc_id            = local.inputs.vpc_id

  enable_cross_zone_load_balancing = false
  idle_timeout                     = 1800
  enable_http2                     = true
  enable_access_logs               = false
  
  default_ssl_policy     = "ELBSecurityPolicy-2016-08"
  default_certificate_arn = local.inputs.alb_certificate_arn

  target_groups = [
    {
      name        = "${local.inputs.servers.guac.name}-tg"
      port        = 443
      protocol    = "HTTPS"
      target_type = "instance"
      health_check = {
        enabled             = true
        protocol            = "HTTPS"
        path                = "/"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
        matcher             = "200"
      }
    }
  ]

  listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-2016-08"
      certificate_arn = local.inputs.alb_certificate_arn
      default_action = {
        type             = "forward"
        target_group_key = 0
        redirect         = null
      }
    },
    {
      port            = 80
      protocol        = "HTTP"
      ssl_policy      = null
      certificate_arn = null
      default_action = {
        type             = "redirect"
        target_group_key = null
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
    }
  ]

  tags = local.inputs.tags
}