

locals {
    new2 = flatten([
    for k in keys(var.organizations) : 
        { "org_name" = k }  
    ])
  
  # convert into a map to be iterable
  organizations = tomap({ 
    for item in local.new2 : item.org_name => item
  })
  
    units = flatten([for k, v in var.organizations:
                 flatten([for dataset, units in v: 
                           [for unit_name, zz in units:
                            {"org" = k
                            "name" = unit_name
                            "unit_name" = zz.name
                            "unit_email" = zz.email
                            "unit_role" = zz.role_name
                            "unit_zones" = zz.zones
                            }
                         ]])
                   ])

parent_orgs = {
    for key, value in module.aws_organizations :
      key => value.orgs[key].parent_org
  }



parent_ou = merge([for item in module.aws_ou : item.ou]...)





}