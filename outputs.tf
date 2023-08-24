output "lb_url" {
  value       = aws_lb.nginx_lb.dns_name
  description = "The public URL of the LoadBalancer"
}
