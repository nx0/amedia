output "orgs" {
    value = {
        (aws_organizations_organizational_unit.master.name) = { 
            "parent_org" = aws_organizations_organizational_unit.master.id
        }
    }
}