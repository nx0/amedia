
data "aws_organizations_organization" "current" {}


resource "aws_organizations_organizational_unit" "master" {

  name      = var.name
  parent_id = data.aws_organizations_organization.current.roots[0].id

}