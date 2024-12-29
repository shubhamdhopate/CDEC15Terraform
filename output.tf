output "aws_lb_dns" {
  value = aws_lb.application.dns_name
}