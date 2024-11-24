# Local terraform state
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}


data "aws_organizations_organization" "current" {}

# Create organizations
module "aws_organizations" {

  # generates a map from an object map to iterate over
  for_each = local.organizations

  source = "./modules/organization"
  name   = each.value.org_name
}

# Create organizations units
module "aws_ou" {

  # generates a map from an object map to iterate over
  for_each = { for idx, record in local.units : idx => record }

  source       = "./modules/ou"
  name         = each.value.org
  organization = each.value.name
  email        = each.value.unit_email
  role_name    = each.value.unit_role
  parent_id = local.parent_orgs[each.value.org]

  aws_account = var.account
}

# Create accounts module
module "aws_accounts" {
  for_each = { for idx, record in local.units : idx => record }

  source    = "./modules/account"
  name      = each.value.name
  email     = each.value.unit_email # Ensure this email is unique and valid
  role_name = each.value.unit_role
  parent_id = local.parent_ou["${each.value.name}_${each.value.org}"]

  dns_zones = each.value.unit_zones

  depends_on = [
    module.aws_organizations
  ]
}