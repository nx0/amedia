resource "aws_organizations_account" "oa" {
  name      = var.name
  email     = var.email
  role_name = var.role_name
  parent_id = var.parent_id
}

module "route53" {
  for_each = var.dns_zones
  source    = "../../modules/route53"
  zone      = each.key
  zone_name     = each.value.name
  zone_type = each.value.type
  records = each.value.records
  ttl = each.value.ttl
}