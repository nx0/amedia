#output "org_id" {
#    value = aws_organizations_organization.org.*.id
#}

#output "org_account" {
#    value = aws_organizations_organization.org.accounts
#}

#output "org_arn" {
#    value = aws_organizations_organization.org.*.arn
#}

#output "ou" {
#    value = aws_organizations_organizational_unit.ou
#}
output "ou" {
    value = {
        (aws_organizations_organizational_unit.ou.name) = { 
            "ou" = aws_organizations_organizational_unit.ou.id
        }
    }
}

output "is_member" {
    value = contains(data.aws_organizations_organization.current.accounts[*].name, var.name)
}

#output "testing" {
#    value = aws_organizations_organization.org.id
#}
#