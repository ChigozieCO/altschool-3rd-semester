variable "oac-name" {
  description = "This is the name of the cloudfront origin Access control with s3 bucket origin domain"
  type = string
  default = "s3-bucket-oac"
}

variable "origin_access_control_origin_type" {
  description = "The origin type must be the same as the origin domain"
  type = string
  default = "s3"
}

variable "signing_behavior" {
  description = "Specifies which requests CloudFront signs."
  type = string
  default = "always"
}

variable "signing_protocol" {
  description = "Determines how CloudFront signs (authenticates) requests."
  type = string
  default = "sigv4" # The only valid value
}

variable "restriction_type" {
  description = "Method that you want to use to restrict distribution of your content by country"
  type = string
  default = "none"
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return when an end user requests the root URL."
  type = string
  default = "index.html"
}

variable "domain_name" {
  description = "your custom Domain name for which the certificate should be issued"
  type = string
}

variable "cdn-domain_name-and-origin_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}