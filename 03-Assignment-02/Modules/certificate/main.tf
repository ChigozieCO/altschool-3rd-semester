resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = var.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validate-cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_acm_certificate.example.domain_validation_options.0.resource_record_name]
}