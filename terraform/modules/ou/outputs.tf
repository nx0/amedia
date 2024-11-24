# Returns the organization unit map map ids that will be used 
# by the account module with the format myou + _ + mycompany. 
# Example:
#
#{
#  "my-ou1_my-company" = "ou-7ycx-qvl341y5"
#  "my-ou2_my-company" = "ou-7ycx-rqd05jmx"
#}

output "ou" {
  value = { "${var.organization}_${var.name}" = (aws_organizations_organizational_unit.ou.id) }
}


output "is_member" {
  value = contains(data.aws_organizations_organization.current.accounts[*].name, var.name)
}


output "org" {
  value = data.aws_organizations_organization.current.roots
}