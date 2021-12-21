# outputs you can kist required endpoints, ip or instanceid's

output "alb_hostname" {
  value = aws_lb.demo-app.dns_name
}