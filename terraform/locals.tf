

locals {
  org_names = flatten([
    for k in keys(var.organizations) :
    { "org_name" = k }
  ])

  # Convert into a map to be iterable
  organizations = tomap({
    for item in local.org_names : item.org_name => item
  })

  # Extracts all the units for all the organizations. Returns
  # a map with all the organizations. Example:
  #
  # {
  #  "name" = "my-ou"
  #  "org" = "my-company"
  #  "unit_email" = "ou1@example.com"
  #  "unit_name" = "DevelopmentAccount"
  #  "unit_role" = "OrganizationAccountAccessRole"
  #  "unit_zones" = {
  #    "example.com" = {
  #      "name" = "www"
  #      "records" = [
  #        "192.0.2.1",
  #      ]
  #      "ttl" = 300
  #      "type" = "A"
  #    }
  #  }
  #}
  units = flatten([for k, v in var.organizations :
    flatten([for dataset, units in v :
      [for unit_name, zz in units :
        { "org"        = k
          "name"       = unit_name
          "unit_name"  = zz.name
          "unit_email" = zz.email
          "unit_role"  = zz.role_name
          "unit_zones" = zz.zones
        }
    ]])
  ])

  # Print all the parent orgs created
  parent_orgs = {
    for key, value in module.aws_organizations :
    key => value.orgs[key].parent_org
  }

  # Print all the parents ou units created
  parent_ou = merge([for item in module.aws_ou : item.ou]...)

}