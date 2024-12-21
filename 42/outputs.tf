output "sas_alb_dns" {
  description = "DNS name of the SAS Application Load Balancer"
  value       = module.sas_alb.lb_dns_name
}

output "guac_alb_dns" {
  description = "DNS name of the GUAC Application Load Balancer"
  value       = module.guac_alb.lb_dns_name
}

output "cdr_nlb_dns" {
  description = "DNS name of the CDR Network Load Balancer"
  value       = module.cdr_nlb.lb_dns_name
}

output "sftp_nlb_dns" {
  description = "DNS name of the SFTP Network Load Balancer"
  value       = module.sftp_nlb.lb_dns_name
}
