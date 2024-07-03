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
  type = list(string)
  default = []
}

variable "validation_record_fqdns" {
  type = string
}