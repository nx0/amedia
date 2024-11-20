organizations = {
  "my-aws-org" = {
    unit = "my-ui"
    dns = []
  }
}

units = {
  "my-ou" = {
    parent = "my-aws-org"
  }
}
