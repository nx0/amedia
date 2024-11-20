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

module "aws_organizations" {

  # generates a map from an object map to iterate over
  for_each =  { for idx, record in local.units : idx => record }
  

  source    = "./modules/organization"
  name      = each.value.unit_name
  email     = each.value.unit_email
  role_name = each.value.unit_role

  
  #feature_set = "ALL"
  #aws_service_access_principals = ["sso.amazonaws.com"]
  #enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

#module "aws_accounts" {
#  for_each  = var.organization
#  source    = "./modules/account"
#  name      = "DevelopmentAccount"
#  email     = "dev-account@example.com"  # Ensure this email is unique and valid
#  role_name = "OrganizationAccountAccessRole"
#  parent_id = aws_organizations_organizational_unit.development.id
#}