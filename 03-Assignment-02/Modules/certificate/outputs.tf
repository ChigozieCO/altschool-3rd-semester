output "cert-arn" {
  value = aws_acm_certificate.cert.arn
}

output "domain_validation_options" {
  value = [for o in aws_acm_certificate.cert.domain_validation_options : o]
}