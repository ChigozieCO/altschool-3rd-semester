# # Define the imported Route 53 hosted zone
# resource "aws_route53_zone" "assign-domain" {
#   name = var.domain_name

#   # Add a lifecycle rule cos we don't want terraform to destroy the imported hosted zone
#   lifecycle {
#     prevent_destroy = true
#   }
# }