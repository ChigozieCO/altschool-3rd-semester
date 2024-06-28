resource "aws_s3_bucket" "site-bucket" {
  bucket = var.bucket_name
  force_destroy = true
}