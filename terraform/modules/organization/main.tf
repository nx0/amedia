data "aws_ssoadmin_instances" "main" {}
data "aws_organizations_organization" "current" {}

locals {
  sso_instance_arns = tolist(data.aws_ssoadmin_instances.main.arns)
  has_sso_instance  = length(local.sso_instance_arns) > 0
  is_member = contains(data.aws_organizations_organization.current.accounts[*].name, var.name)
}

#resource "aws_organizations_organization" "org" {
#  #count = local.is_member ? 0 : 0
#
#  aws_service_access_principals = [
#    "cloudtrail.amazonaws.com",
#    "config.amazonaws.com",
#    "sso.amazonaws.com"
#  ]
#
#  feature_set = "ALL"
#}

resource "aws_organizations_organizational_unit" "ou" {
  name      = var.organization
  parent_id = "r-7ycx"
  #parent_id = local.is_member ? data.aws_organizations_organization.current.id : aws_organizations_organization.org[0].roots[0].id
  #parent_id = local.is_member ? "ou-7ycx-qdoh3v03" : "r-7ycx"
  #parent_id = "ou-7ycx-qdoh3v03"

}

resource "aws_identitystore_group" "main" {
  count = local.has_sso_instance ? 1 : 0
  display_name      = "Example group"
  description       = "Example description"
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

resource "aws_ssoadmin_permission_set" "main" {
  count            = local.has_sso_instance ? 1 : 0
  name            = "AdminPermissionSet"
  description     = "Full administrative access"
  instance_arn    = tolist(data.aws_ssoadmin_instances.main.arns)[0]  # Get the first instance ARN
  relay_state     = "https://console.aws.amazon.com/"
  session_duration = "PT8H"  # Session duration for the permission set
}

resource "aws_ssoadmin_managed_policy_attachment" "main" {
  count            = local.has_sso_instance ? 1 : 0
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.main[0].arn
}

resource "aws_ssoadmin_account_assignment" "admin_assignment" {
  count            = local.has_sso_instance ? 1 : 0
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main[0].arn
  principal_id      = aws_identitystore_group.main[0].id
  principal_type    = "GROUP"

  #account_id        = "051826722573"  # Replace with your AWS account ID
  target_id   = "051826722573"
  target_type = "AWS_ACCOUNT"
}