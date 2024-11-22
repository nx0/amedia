variable "zone" {}

variable "zone_name" {}
variable "zone_type" {}
variable "ttl" {}
variable "records" {
  type    = list(string)
  default = ["192.0.2.1"]
}