resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets           = var.subnets
  
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  idle_timeout                     = var.idle_timeout
  enable_http2                     = var.enable_http2
  
  dynamic "access_logs" {
    for_each = var.enable_access_logs ? [1] : []
    content {
      bucket  = var.access_logs_config.bucket
      prefix  = var.access_logs_config.prefix
      enabled = true
    }
  }

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  for_each = { for idx, tg in var.target_groups : idx => tg }

  name        = each.value.name
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  dynamic "health_check" {
    for_each = [each.value.health_check]
    content {
      enabled             = try(health_check.value.enabled, true)
      healthy_threshold   = try(health_check.value.healthy_threshold, 3)
      interval           = try(health_check.value.interval, 30)
      matcher            = try(health_check.value.matcher, "200")
      path               = try(health_check.value.path, "/")
      port               = try(health_check.value.port, "traffic-port")
      protocol           = try(health_check.value.protocol, "HTTP")
      timeout            = try(health_check.value.timeout, 5)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, 3)
    }
  }

  tags = var.tags
}

resource "aws_lb_listener" "this" {
  count = length(var.listeners)

  load_balancer_arn = aws_lb.this.arn
  port              = var.listeners[count.index].port
  protocol          = var.listeners[count.index].protocol
  ssl_policy        = var.listeners[count.index].ssl_policy
  certificate_arn   = var.listeners[count.index].certificate_arn

  dynamic "default_action" {
    for_each = [var.listeners[count.index].default_action]
    content {
      type = default_action.value.type

      dynamic "forward" {
        for_each = default_action.value.type == "forward" ? [1] : []
        content {
          target_group {
            arn    = aws_lb_target_group.this[default_action.value.target_group_key].arn
            weight = 100
          }
          stickiness {
            enabled  = false
            duration = 1
          }
        }
      }

      dynamic "redirect" {
        for_each = default_action.value.type == "redirect" ? [default_action.value.redirect] : []
        content {
          port        = redirect.value.port
          protocol    = redirect.value.protocol
          status_code = redirect.value.status_code
          host        = try(redirect.value.host, null)
          path        = try(redirect.value.path, null)
          query       = try(redirect.value.query, null)
        }
      }
    }
  }

  tags = var.tags
}
