terraform {
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = "~> 0.7.0"
    }
  }
  required_version = ">= 0.13"
}

locals {
  vmm_domain = "uni/vmmp-VMware/dom-vmm_vds"
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

resource "aci_bridge_domain" "demo_bd02" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.2.0_24_bd"
  arp_flood          = "yes"
  unicast_route      = "yes"
  unk_mac_ucast_act  = "proxy"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "demo_net02" {
  parent_dn = aci_bridge_domain.demo_bd02.id
  ip        = "192.168.2.1/24"
  scope     = ["private"]
}

resource "aci_bridge_domain" "demo_bd03" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.3.0_24_bd"
  arp_flood          = "yes"
  unicast_route      = "yes"
  unk_mac_ucast_act  = "proxy"
  unk_mcast_act      = "flood"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "demo_net03" {
  parent_dn = aci_bridge_domain.demo_bd03.id
  ip        = "192.168.3.1/24"
  scope     = ["private"]
}

### Application Profiles and EPGs

# App Profiles
resource "aci_application_profile" "demo_app" {
  name      = "demo_app"
  tenant_dn = aci_tenant.demo.id
}

# App Endpoint Groups
resource "aci_application_epg" "epg01" {
  name         = "net01_epg"
  pref_gr_memb = "include"

  application_profile_dn = aci_application_profile.demo_app.id
  relation_fv_rs_bd      = aci_bridge_domain.demo_bd01.id
}

resource "aci_application_epg" "epg02" {
  name         = "net02_epg"
  pref_gr_memb = "include"

  application_profile_dn = aci_application_profile.demo_app.id
  relation_fv_rs_bd      = aci_bridge_domain.demo_bd02.id
}

resource "aci_application_epg" "epg03" {
  name         = "net03_epg"
  pref_gr_memb = "include"

  application_profile_dn = aci_application_profile.demo_app.id
  relation_fv_rs_bd      = aci_bridge_domain.demo_bd03.id
}

# App Endpoint Group - Domain Association
resource "aci_epg_to_domain" "epg01_vmmdom" {
  application_epg_dn = aci_application_epg.epg01.id
  tdn                = local.vmm_domain
}

resource "aci_epg_to_domain" "epg02_vmmdom" {
  application_epg_dn = aci_application_epg.epg02.id
  tdn                = local.vmm_domain
}

resource "aci_epg_to_domain" "epg03_vmmdom" {
  application_epg_dn = aci_application_epg.epg03.id
  tdn                = local.vmm_domain
}
