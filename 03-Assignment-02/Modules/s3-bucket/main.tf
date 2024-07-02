# Create S3 Bucket
resource "aws_s3_bucket" "site-bucket" {
  bucket = var.bucket-name
  force_destroy = true
}

# Upload objects into the s3 Bucket
resource "aws_s3_object" "upload-assets" {
  for_each = fileset("${var.web-assets-path}", "**/*")
  bucket = aws_s3_bucket.site-bucket.bucket
  key = each.value
  source = "${var.web-assets-path}/${each.value}"
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}

# Add the permissions needed by cloudfront's origin access control to access the buscket and it's objects
resource "aws_s3_bucket_policy" "cloudfront-oac-policy" {
  bucket = aws_s3_bucket.site-bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.site-bucket.arn}/*",
        Condition = {
          StringLike = {
            "aws:UserAgent" = "Amazon CloudFront"
          }
        }
      }
    ]
  })
}