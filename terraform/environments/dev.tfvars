account = "051826722573"
organizations = {
  "my-companyx" = {
    "units" = {
      "my-ou1x" = {
        "name"      = "DevelopmentAccount"
        "email"     = "ou1@example.com"
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
      "my-ou2x" = {
        "name"      = "DevelopmentAccount"
        "email"     = "ou2@example.com"
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
  },
  "my-company2x" = {
    "units" = {
      "my-ou1x" = {
        "name"      = "DevelopmentAccount"
        "email"     = "ou1@example.com"
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
      "my-ou2x" = {
        "name"      = "DevelopmentAccount"
        "email"     = "ou2@example.com"
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