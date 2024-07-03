# Retrieve information about your hosted zone from AWS
data "aws_route53_zone" "created" {
  name = var.domain_name
}

# Create an alias that will point to the cloudfront distribution domain name
resource "aws_route53_record" "alias" {
  zone_id                  = data.aws_route53_zone.created.zone_id
  name                     = var.domain_name
  type                     = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront-zone-id
    evaluate_target_health = false
  }
}