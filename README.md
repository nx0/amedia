

# Usage example

./terraform init
./terraform plan -var-file environments/dev.yaml -o /tmp/
./terraform apply -auto-approve 

Note: To simplify the test, the Terraform's state backend has been configured as "local".
```yaml
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```
A production ready environment should have a bucket configured to be storage in a safe place with versioning enabled. For example an S3 bucket or similiar.

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

There's a method for transmitting credentials safely. For this demo we will use a short demostration:
Visit: https://github.com/getsops/sops/releases for downloading and installing instructions.
```
sudo apt-get -y install age
age-keygen -o /tmp/key.txt
export SOPS_AGE_KEY_FILE=/tmp/key.txt
sops decrypt /tmp/creds.enc.txt
```
This will decript the credentials that can be used for the provider.

## Configure an organization

Inside the folder environments/ you'll find the environments env files that contains the organizations definition for each environment.

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
      },
    }
  }
}

```

That's allow you to create easily as many units as you want inside your organization by simple adding an unit config map:
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

* organization: Creates the Organization Units and the Policies for the organization

* account: Creates an organization account inside the specified Organization Unit

* route53: Creates the dns entries for an account