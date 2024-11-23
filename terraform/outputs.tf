
#output "orgs" {
#    value = local.organizations
#}



#output "final" {
#    value = local.m
#}

output "porg" {
  value = local.parent_orgs
}


output "all" {
  value = local.units
}





output "raw_org" {
  value = module.aws_organizations
}

output "raw_ou" {
  #value = module.aws_ou
  value = local.parent_ou
}