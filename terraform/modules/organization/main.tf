resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com"
  ]

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "ou" {
  name      = var.name
  parent_id = aws_organizations_organization.org.roots[0].id
}

data "aws_ssoadmin_instances" "main" {}

resource "aws_identitystore_group" "main" {
  display_name      = "Example group"
  description       = "Example description"
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

resource "aws_ssoadmin_permission_set" "main" {
  name            = "AdminPermissionSet"
  description     = "Full administrative access"
  instance_arn    = tolist(data.aws_ssoadmin_instances.main.arns)[0]  # Get the first instance ARN
  relay_state     = "https://console.aws.amazon.com/"
  session_duration = "PT8H"  # Session duration for the permission set
}

#resource "aws_ssoadmin_permission_set" "main" {
#  name         = "Example"
#  instance_arn = tolist(data.aws_ssoadmin_instances.main.arns)[0]
#}

resource "aws_ssoadmin_managed_policy_attachment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.main.arn
}

resource "aws_ssoadmin_account_assignment" "admin_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.main.arn
  principal_id      = aws_identitystore_group.main.id
  principal_type    = "GROUP"

  #account_id        = "051826722573"  # Replace with your AWS account ID
  target_id   = "051826722573"
  target_type = "AWS_ACCOUNT"
}