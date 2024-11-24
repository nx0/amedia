
data "aws_organizations_organization" "current" {}

# For testing purposes, this was ommited as the provider 
# doesn't let you to create an organization with a name. Instead
# the organization was replaced by an organization unit
# 
#resource "aws_organizations_organization" "org" {
#  aws_service_access_principals = [
#    "cloudtrail.amazonaws.com",
#    "config.amazonaws.com",
#  ]
#
#  feature_set = "ALL"
#}

resource "aws_organizations_organizational_unit" "master" {
  name      = var.name
  parent_id = data.aws_organizations_organization.current.roots[0].id
}