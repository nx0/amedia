resource "aws_route53_zone" "my_zone" {
  name = var.zone # Reemplaza con tu dominio
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name     = var.zone_name
  type     = var.zone_type
  ttl      = var.ttl
  records  = var.records 
}