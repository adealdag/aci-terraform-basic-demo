terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

### Provider Configuration

provider "aci" {
  url      = var.aci_url
  username = var.aci_username
  password = var.aci_password
  # private_key = "file(/Users/adealdag/.ssh/labadmin.key)"
  # cert_name = "labadmin.crt"
  insecure = true
}