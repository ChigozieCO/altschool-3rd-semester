output "cert_validation_record_fqdns" {
  value = [for record in aws_route53_record.cert_validation : record.fqdn]
}

output "dns_records" {
  value = aws_route53_record.cert_validation
}