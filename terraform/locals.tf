

locals {
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


    ou_map = {
    for ou in local.units : 
    ou.name => {
      name = ou.name
      org         = ou.org
      unit_email  = ou.unit_email
      unit_name   = ou.unit_name
      unit_role   = ou.unit_role
      unit_zones  = ou.unit_zones
    }
    }

proxy = {
    for user in module.aws_organizations : 
    keys(user.ou)[0] => {
      ou = user.ou[keys(user.ou)[0]].ou
    }
  }

    m = merge(
    {
      for key in keys(local.ou_map) : key => merge(local.ou_map[key], { ou = local.proxy[key].ou })
    }
  )









}