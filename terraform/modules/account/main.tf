resource "aws_organizations_account" "oa" {
  name      = var.name
  email     = var.email
  role_name = var.role_name
  parent_id = var.parent_id
}