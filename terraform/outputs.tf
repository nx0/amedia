output "unit_names" {
  value = local.units
}

output "mierda" {
    value = local.m
}

output "from_zones" {
    value = module.aws_accounts.my-ou2.zones
}
