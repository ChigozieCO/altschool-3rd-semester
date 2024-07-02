# Retrieve information about your hosted zone from AWS
data "aws_route53_zone" "created" {
  name = var.domain_name
}

# Define the imported Route 53 hosted zone
resource "aws_route53_zone" "assign-domain" {
  name = var.domain_name

  # Add a lifecycle rule cos we don't want terraform to destroy the imported hosted zone
  lifecycle {
    prevent_destroy = true
  }
}

# Import the already created hosted zone
import {
  to = aws_route53_zone.assign-domain
  id = data.aws_route53_zone.created
}

# Create DNS record that will be used for our certificate validation
resource "aws_route53_record" "cert-dns" {
  allow_overwrite = true
  name            = module.certificate.aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  records         = [module.certificate.aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  type            = module.certificate.aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  zone_id         = aws_route53_zone.assign-domain.zone_id
  ttl             = 60
}

# Create an alias that will point to the cloudfront distribution domain name
resource "aws_route53_record" "alias" {
  zone_id = aws_route53_zone.assign-domain.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront.aws_cloudfront_distribution.cdn.domain_name
    zone_id                = module.cloudfront.aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# Create CNAME Record for WWW Subdomain
resource "aws_route53_record" "www" {
  zone_id = module.cloudfront.aws_cloudfront_distribution.cdn.hosted_zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain_name]
}