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

# # Create DNS record that will be used for our certificate validation
# resource "aws_route53_record" "cert_validation" {
#   for_each   = { for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#     name     = dvo.resource_record_name
#     type     = dvo.resource_record_type
#     record   = dvo.resource_record_value
#   } }

#   zone_id  = data.aws_route53_zone.created.zone_id
#   name       = each.value.name
#   type       = each.value.type
#   records    = [each.value.record]
#   ttl        = 60
# }

# # Validate the certificate
# resource "aws_acm_certificate_validation" "validate-cert" {
#   certificate_arn = aws_acm_certificate.cert.arn
#   validation_record_fqdns = var.validation_record_fqdns

#   depends_on = [var.route53_dns_records]
# }