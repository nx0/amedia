output "unit_names" {
  value = local.units
}

#output "xxx" {
#    value = module.aws_organizations.0.ou
#}
#
#output "acc" {
#    value = module.aws_organizations
#}
#
#output "xxxxxxx" {
#    value = contains(data.aws_organizations_organization.current.accounts[*].name, "my-ou2" )
#}
#


output "oux" {
    value = module.aws_organizations
}

output "mierda" {
    value = local.m
}


