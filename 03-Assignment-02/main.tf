# Create S3 bucket, upload objects into the bucket and set bucket policy.
module "s3-bucket" {
  source = "./Modules/s3-bucket"
  bucket-name = var.bucket-name
  web-assets-path = var.web-assets-path
}

# Create and validate TLS/SSL certificate
module "certificate" {
  source = "./Modules/certificate"
  domain_name = var.domain_name
  validation_record_fqdns = module.route53.cert_dns_fqdn
  subject_alternative_names  = ["www.${var.domain_name}"]
}

# Create OAC and cloudfront distribution, 
module "cloudfront" {
  source = "./Modules/cloudfront"
  domain_name = var.domain_name
  cdn-domain_name-and-origin_id = module.s3-bucket.bucket_regional_domain_name
  acm_certificate_arn = module.certificate.cert-arn
}

# Import the hosted zone from AWS, create dns records for certificate validation, and create A and CNAME records.
module "route53" {
  source = "./Modules/route53"
  domain_name = var.domain_name
  cert-dns-name-and-type =[
    module.certificate.domain_validation_options[0].resource_record_name,
    module.certificate.domain_validation_options[0].resource_record_type
  ]
  cert-dns-records = [module.certificate.domain_validation_options[0].resource_record_value]
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront-zone-id = module.cloudfront.cloudfront_hosted-zone_id
  route53-hosted-zone-id = module.hosted-zone.hosted-zone-zone_id
}

module "hosted-zone" {
  source = "./Modules/hosted-zone"
  domain_name = var.domain_name
}

# Retrieve information about your hosted zone from AWS
data "aws_route53_zone" "created" {
  name = var.domain_name
}

# Import the already created hosted zone
import {
  to = module.hosted-zone.aws_route53_zone.assign-domain
  id = data.aws_route53_zone.created.zone_id
}