

# Usage example

./terraform init
./terraform plan -var-file environments/dev.yaml
./terraform apply -auto-approve=true -var-file environments/dev.yaml 

Note: To simplify the test, the Terraform's state backend has been configured as "local".
```yaml
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```
A production ready environment should have a bucket configured to be storage in a safe place with versioning enabled. For 
example an S3 bucket or similiar. Example:
```yaml
terraform {
  backend "s3" {
    bucket = "bucket-name"
    key    = "s3/bucket/path/terraform.tfstate"
    region = "us-west-2"
  }
}
```
# Usage

## Preparation

For obvious reasons, the provider.tf file has been provided empty:

```yaml
provider "aws" {
  region     = "us-west-1" 
  access_key = [REDACTED]
  secret_key = [REDACTED]
}
```

Edit the terraform/provider.tf file and add your region/access and secret key.
For the testing, region is not quite relevant as we will be creating organizations and organizations has no regions but
for access and secrets keys you will need an user. Head to the following url to create an user 
https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/users/create

And attach the following policies:

* arn:aws:iam::aws:policy/AdministratorAccess
* arn:aws:iam::aws:policy/AWSOrganizationsFullAccess

> [!NOTE] In a production ready environment, the AdministratorAccess is not recomendable. In such case we may need a more
> restrictive permissions.

After creating your key, select the user and Create access key for him. 
The use case should be CLI.
After that you'll be able to see the access/secret key. Edit terraform/provider.tf with the user information


## Configure an organization

Inside the folder environments/ you'll find the environments env files that contains the organizations definition for 
each environment. dev.tfvars, staging.tfvars and staging.tfvars

The structure is as follows:
```yaml
organizations = {
  "my-aws-org" = {
    "units" = {
      "my-unit" = {
        "name"      = "DevelopmentAccount"
        "email"     = "dev-accountxvvv@example.com"
        "role_name" = "OrganizationAccountAccessRole"
        "zones" = {
          "example.com" = {
            name     = "www"
            type     = "A"
            ttl      = 300
            records  = ["192.0.2.1"]
          }
        }
      }
    }
  }
}

```

That will allow you to create easily as many units as you want inside your organization by simple adding an unit config map:
```yaml
"my-unit" = {
  "name"      = "DevelopmentAccount"
  "email"     = "dev-accountxvvv@example.com"
  "role_name" = "OrganizationAccountAccessRole"
  "zones" = {
    "example.com" = {
      name     = "www"
      type     = "A"
      ttl      = 300
      records  = ["192.0.2.1"]
    }
  }
}
```

You can also create different organizations by adding organization blocks inside the configuration block:
```yaml
"my-org" = {
  "units" = {
    ...
  }
},
"my-org2" = {
  "units" = {
    ...
  }
},
```

## Available modules

* organization: Creates the main organization that belongs to the default "Root"
* ou: Creates the Organization Units and the Policies for the organization 
* account: Creates an organization account inside the specified Organization Unit
* route53: Creates the dns entries for an account

## Deep dive explanation

While executing the main.tf file (default) inside the terraform/ folder, main will instantiate all the required modules 
to create our accounts/organizations, etc...

### Organization module
The call over the organization module will be in a for_each for every organization found in the "organizations" map (key), 
defined in one of the environments files.
The map is created with an org_name entry
```yaml
  org_names = flatten([
    for k in keys(var.organizations) :
    { "org_name" = k }
  ])
```

afterwards, every entry is transformed into a map to be iterable by for_each
```yaml
  organizations = tomap({
    for item in local.org_names : item.org_name => item
  })
```

The organization module will returns the organization id of all the organizations we created. This is will be used by the 
organization module to be able to be attached to the corresponding ou id.
```yaml
{
  my-company = {
    parent_org = ou-dsv7-3wxgk587
}
```

### Ou module
Later, the ou module is called, that will iterate over all the units that belongs to the organization
```yaml
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
```
> [!TIP]
> note that in this case, we will be including the organization name as part of the map, in order for us to be easy to 
> iterate over the organization unit As in this case we obtain a list or array, we will need to transform this into a map, 
> to be able to use each item inside the for_each loop. 

To do so we iterate over as follows:
```yaml
for_each = { for idx, record in local.units : idx => record }
```

This basically assign the value of each index (idx) to a record (value).

The ou module will return a map of id's with the following format: ou + _ + company

This is to easily iterate over the map directly and avoid transform the list into a map again
```yaml
{
  "my-ou1_my-company" = "ou-7ycx-qvl341y5"
  "my-ou2_my-company" = "ou-7ycx-rqd05jmx"
}
```

### Accounts map
Last one, accounts map will be called. The iteration is exactly the same as the ou module, but this time we will be using the 
parent_id of our returned ou + company combo.
```yaml
  parent_id = local.parent_ou["${each.value.name}_${each.value.org}"]
```

Notice in this module, we will be calling the route53 module and iterating over the dns_zones ("unit_zones" in our organization map):
```yaml
"zones" = {
  "example.com" = {
    name     = "www"
    type     = "A"
    ttl      = 300
    records  = ["192.0.2.1"]
  }
}
```
so inside the module we will be iterating over all the zones and creating everything needed.

```yaml
module "route53" {
  for_each  = var.dns_zones

  source    = "../../modules/route53"
  zone      = each.key
  zone_name = each.value.name
  zone_type = each.value.type
  records   = each.value.records
  ttl       = each.value.ttl
}
```

That's everything.

Thank you for reading