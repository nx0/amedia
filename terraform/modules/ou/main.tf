data "aws_ssoadmin_instances" "main" {}
data "aws_organizations_organization" "current" {}


locals {
  sso_instance_arns = tolist(data.aws_ssoadmin_instances.main.arns)
  has_sso_instance  = length(local.sso_instance_arns) > 0
  is_member = contains(data.aws_organizations_organization.current.accounts[*].name, var.name)
}


resource "aws_organizations_organizational_unit" "ou" {
  name      = var.organization
  parent_id = var.parent_id
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

  target_id   = var.aws_account
  target_type = "AWS_ACCOUNT"
}