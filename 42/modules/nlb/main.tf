resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "network"
  subnets           = var.subnets
  
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  
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
      port               = try(health_check.value.port, "traffic-port")
      protocol           = try(health_check.value.protocol, "TCP")
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

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.listeners[count.index].default_action.target_group_key].arn
  }

  tags = var.tags
}
