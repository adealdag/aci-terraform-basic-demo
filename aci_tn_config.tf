# Tenant Definition
resource "aci_tenant" "demo" {
  name = "demo_tn"
}

# Networking Definition
resource "aci_vrf" "demo" {
  tenant_dn = aci_tenant.demo.id
  name      = "demo_vrf"
}

resource "aci_bridge_domain" "bd_192_168_1_0" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.1.0_24_bd"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "subnet_192_168_1_1" {
  parent_dn = aci_bridge_domain.bd_192_168_1_0.id
  ip        = "192.168.1.1/24"
  scope     = ["private"]
}

resource "aci_bridge_domain" "bd_192_168_2_0" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.2.0_24_bd"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "subnet_192_168_2_1" {
  parent_dn = aci_bridge_domain.bd_192_168_2_0.id
  ip        = "192.168.2.1/24"
  scope     = ["private"]
}

resource "aci_bridge_domain" "bd_192_168_3_0" {
  tenant_dn          = aci_tenant.demo.id
  name               = "192.168.3.0_24_bd"
  relation_fv_rs_ctx = aci_vrf.demo.id
}

resource "aci_subnet" "subnet_192_168_3_1" {
  parent_dn = aci_bridge_domain.bd_192_168_3_0.id
  ip        = "192.168.3.1/24"
  scope     = ["private"]
}
