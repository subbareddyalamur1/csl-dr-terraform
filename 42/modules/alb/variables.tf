variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout value"
  type        = number
  default     = 60
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_access_logs" {
  description = "Enable access logs"
  type        = bool
  default     = false
}

variable "access_logs_config" {
  description = "Access logs configuration"
  type = object({
    bucket = string
    prefix = string
  })
  default = null
}

variable "target_groups" {
  description = "List of target group configurations"
  type        = list(any)
}

variable "listeners" {
  description = "List of listener configurations"
  type = list(object({
    port        = number
    protocol    = string
    ssl_policy  = optional(string)
    certificate_arn = optional(string)
    default_action = object({
      type             = string
      target_group_key = number
      redirect = object({
        port        = string
        protocol    = string
        status_code = string
      })
    })
  }))
}

variable "default_ssl_policy" {
  description = "Default SSL policy for HTTPS listeners"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "default_certificate_arn" {
  description = "Default certificate ARN for HTTPS listeners"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
