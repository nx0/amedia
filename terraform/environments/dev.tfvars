account = "051826722573"
organizations = {
  "my-aws-org" = {
    "units" = {
      "my-ou" = {
        "name"      = "DevelopmentAccount"
        "email"     = "example@example.com"
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