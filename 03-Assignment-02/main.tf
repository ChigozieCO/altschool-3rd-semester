module "s3-bucket" {
  source = "./Modules/s3-bucket"
  bucket_name = var.bucket_name
}