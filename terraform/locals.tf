locals {
    units = flatten([for k, v in var.organizations:
                 flatten([for dataset, roles in v: 
                           [for role, zz in roles:
                            {"org" = k
                            "dataset" = dataset
                            "role" = role
                            "unit_name" = zz.name
                            "unit_email" = zz.email
                            "unit_role" = zz.role_name
                            }
                         ]])
                   ])
}