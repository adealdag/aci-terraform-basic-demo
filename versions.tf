terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 0.13"
}
