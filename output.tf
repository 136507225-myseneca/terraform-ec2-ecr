output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.ALB.alb_dns_name
}