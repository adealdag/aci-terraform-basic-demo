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

### Tenant Definition

resource "aci_tenant" "demo" {
  name = "demo_tn"
}

### Networking Definition

# VRF
resource "aci_vrf" "demo" {
  tenant_dn = aci_tenant.demo.id
  name      = "demo_vrf"
}

# Bridge Domain
resource "aci_bridge_domain" "demo_bd01" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.1.0_24_bd"
  arp_flood          = "yes"
  unicast_route      = "yes"
  unk_mac_ucast_act  = "proxy"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "demo_net01" {
  parent_dn = aci_bridge_domain.demo_bd01.id
  ip        = "192.168.1.1/24"
  scope     = ["private"]
}
