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

module "aws_organization" {
  for_each  = var.organizations
  source = "./modules/org"
  name = "each.key"
  
  feature_set = "ALL"
  aws_service_access_principals = ["sso.amazonaws.com"]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}