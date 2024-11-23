

resource "aws_organizations_organizational_unit" "master" {

  name      = var.name
  parent_id = "r-7ycx"

}