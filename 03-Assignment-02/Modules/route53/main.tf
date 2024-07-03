# Retrieve information about your hosted zone from AWS
data "aws_route53_zone" "created" {
  name = var.domain_name
}

# Create DNS record that will be used for our certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each   = { for dvo in var.domain_validation_options : dvo.domain_name => {
    name     = dvo.resource_record_name
    type     = dvo.resource_record_type
    record   = dvo.resource_record_value
  } }

  name       = each.value.name
  type       = each.value.type
  records    = [each.value.record]
  ttl        = 60
  zone_id  = data.aws_route53_zone.created.zone_id
}

# resource "aws_route53_record" "cert_validation" {
#   count   = length(var.domain_validation_options)
#   name    = var.domain_validation_options[count.index].resource_record_name
#   type    = var.domain_validation_options[count.index].resource_record_type
#   records = [var.domain_validation_options[count.index].resource_record_value]
#   ttl     = 60
#   zone_id = data.aws_route53_zone.created.zone_id
# }

# # Create CNAME Record for WWW Subdomain
# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.created.zone_id
#   name    = "www.${var.domain_name}"
#   type    = "CNAME"
#   ttl     = 300
#   records = [var.domain_name]
# }

# Validate the certificate
resource "aws_acm_certificate_validation" "validate-cert" {
  certificate_arn = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [aws_route53_record.cert_validation]
}