# Returns a list of organizations that will be created. Used by the ou module
# Example:
#
# {
#   my-company = {
#       parent_org = ou-dsv7-3wxgk587
#   }
#}
output "orgs" {
  value = {
    (aws_organizations_organizational_unit.master.name) = {
      "parent_org" = aws_organizations_organizational_unit.master.id
    }
  }
}