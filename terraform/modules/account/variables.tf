variable "name" {
  type        = string
  description = "account name"
}

variable "email" {
  type        = string
  description = "account email"
}

variable "role_name" {
  type        = string
  description = "account role name"
}

variable "parent_id" {
  type        = string
  description = "organization parent id the account will belongs to"
}

variable "dns_zones" {
  description = "dns zones map with the dns records"
}