output "bucket_regional_domain_name" {
  description = "This is the bucket domain name including the region name."
  value = aws_s3_bucket.site-bucket.bucket_regional_domain_name
}

