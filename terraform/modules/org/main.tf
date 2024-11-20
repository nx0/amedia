resource "aws_organizations_organization" "org" {
  name = "var.name"
  aws_service_access_principals = [
    "route53.amazonaws.com"
  ]

  feature_set = "ALL"
}