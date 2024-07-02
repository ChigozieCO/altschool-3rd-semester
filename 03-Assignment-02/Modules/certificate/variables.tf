variable "domain_name" {
  description = "Domain name for which the certificate should be issued"
  type = string
}

variable "validation_method" {
  description = "Which method to use for validation."
  type = string
  default = "DNS"
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate."
  type = string
  default = "www"
}