variable "aci_url" {
  type = string
  description = "APIC URL"
}
variable "aci_username" {
  type = string
  description = "APIC username"
  default = "admin"
}
variable "aci_password" {
  type = string
  description = "APIC password"
  sensitive = true
}