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
  subject_alternative_names  = ["www.${var.domain_name}"]
  # validation_record_fqdns = module.route53.cert_validation_record_fqdns
  # route53_dns_records = module.route53.dns_records
  }

# Create OAC and cloudfront distribution, 
module "cloudfront" {
  source = "./Modules/cloudfront"
  domain_name = var.domain_name
  cdn-domain_name-and-origin_id = module.s3-bucket.bucket_regional_domain_name
  acm_certificate_arn = module.certificate.cert-arn
  depends_on = [ module.route53 ]
}

# Retrieve details of the hosted zone from AWS, create dns records for certificate validation, and create A record.
module "route53" {
  source = "./Modules/route53"
  domain_name = var.domain_name
  domain_validation_options = module.certificate.domain_validation_options
  certificate_arn = module.certificate.cert-arn
  # cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  # cloudfront-zone-id = module.cloudfront.cloudfront_hosted-zone_id
  # depends_on = [ module.cloudfront ]
}

# module "hosted-zone" {
#   source = "./Modules/hosted-zone"
#   domain_name = var.domain_name
# }

# # Retrieve information about your hosted zone from AWS
# data "aws_route53_zone" "created" {
#   name = var.domain_name
# }

# # Import the already created hosted zone
# import {
#   to = module.hosted-zone.aws_route53_zone.assign-domain
#   id = data.aws_route53_zone.created.zone_id
# }

# # Validate the certificate
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = module.certificate.cert-arn
#   validation_record_fqdns = module.route53.cert_validation_record_fqdns
#   depends_on = [module.route53]
# }

# Create an alias to point the cloudfront cdn to our domain name.
module "alias" {
  source = "./Modules/alias"
  domain_name = var.domain_name
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront-zone-id = module.cloudfront.cloudfront_hosted-zone_id
  depends_on = [ module.cloudfront ]
}


# Run terraform apply --target module.certificate first
# Then run terraform apply to build the rest.