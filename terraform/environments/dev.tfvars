organizations = {
  "my-aws-org" = {
    "units" = {
      "my-ou" = {
        "name"      = "DevelopmentAccount"
        "email"     = "dev-account@example.com"
        "role_name" = "OrganizationAccountAccessRole"
        zones = {
          "example.com" = {
            name     = "www"
            type     = "A"
            ttl      = 300
            records  = ["192.0.2.1"]
          }
        }
      }
        }
    },
    "my-aws-org2" = {
    "units" = {
      "my-ou" = {
        "name"      = "DevelopmentAccount"
        "email"     = "dev-account@example.com"
        "role_name" = "OrganizationAccountAccessRole"
        zones = {
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