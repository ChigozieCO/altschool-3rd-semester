output "cloudfront-arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_hosted-zone_id" {
  value = aws_cloudfront_distribution.cdn.hosted_zone_id
}