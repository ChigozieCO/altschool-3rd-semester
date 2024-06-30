# Set variable for bucket name
variable "bucket-name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket-name) >= 3 && length(var.bucket-name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket-name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}

# Set the variable for the file path of the files to be uploaded to the bucket
variable "web-assets-path" {
  description = "This is the location of our website files"
  type = string
}

variable "mime_types" {
  description = "Map of file extensions to MIME types"
  type        = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".pdf"  = "application/pdf"
    "json" = "application/json"
    "js"   = "application/javascript"
    "gif"  = "image/gif"
    # Add more extensions and MIME types as needed
  }
}