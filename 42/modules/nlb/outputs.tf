output "lb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "listener_arns" {
  description = "ARNs of the listeners"
  value       = { for idx, listener in aws_lb_listener.this : var.listeners[idx].port => listener.arn }
}
