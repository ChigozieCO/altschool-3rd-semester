

# Create DNS record that will be used for our certificate validation
resource "aws_route53_record" "cert-dns" {
  allow_overwrite = true
  name            = var.cert-dns-name-and-type[0]
  records         = var.cert-dns-records
  type            = var.cert-dns-name-and-type[1]
  zone_id         = var.route53-hosted-zone-id
  ttl             = 60
}

# Create an alias that will point to the cloudfront distribution domain name
resource "aws_route53_record" "alias" {
  zone_id = var.route53-hosted-zone-id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront-zone-id
    evaluate_target_health = false
  }
}

# Create CNAME Record for WWW Subdomain
resource "aws_route53_record" "www" {
  zone_id = var.cloudfront-zone-id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.domain_name]
}