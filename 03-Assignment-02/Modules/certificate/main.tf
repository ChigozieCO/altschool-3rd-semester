# Create certificate
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  # Ensure that the resource is rebuilt before destruction when running an update
  lifecycle {
    create_before_destroy = true
  }
}

# Validate the certificate
resource "aws_acm_certificate_validation" "validate-cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [module.route53.aws_route53_record.cert-dns.fqdn]
}