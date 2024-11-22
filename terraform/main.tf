#terraform {
#  backend "s3" {
#    bucket = "nombre-de-tu-bucket"
#    key    = "ruta/al/archivo/terraform.tfstate"
#    region = "us-west-2"
#  }
#}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}


data "aws_organizations_organization" "current" {}

module "aws_organizations" {

  # generates a map from an object map to iterate over
  for_each =  { for idx, record in local.units : idx => record }
  

  source    = "./modules/organization"
  name      = each.value.org
  organization = each.value.name 
  email     = each.value.unit_email
  role_name = each.value.unit_role

  
  #feature_set = "ALL"
  #aws_service_access_principals = ["sso.amazonaws.com"]
  #enabled_policy_types = ["SERVICE_CONTROL_POLICY"]

  aws_account = var.account
}

module "aws_accounts" {
  for_each =  { for idx, record in local.m : idx => record }

  source    = "./modules/account"
  name      = each.value.name
  email     = each.value.unit_email # Ensure this email is unique and valid
  role_name = each.value.unit_role
  parent_id = each.value.ou
  dns_zones = each.value.unit_zones

  depends_on = [
    module.aws_organizations
  ]
}