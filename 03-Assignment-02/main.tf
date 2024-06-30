module "s3-bucket" {
  source = "./Modules/s3-bucket"
  bucket-name = var.bucket-name
  web-assets-path = var.web-assets-path
}