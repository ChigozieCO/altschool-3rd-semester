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

