terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

resource "aci_rest_managed" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant = aci_rest_managed.fvTenant.content.name
  name   = "OSPF1"
}

data "aci_rest_managed" "ospfIfPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "ospfIfPol" {
  component = "ospfIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.ospfIfPol.content.name
    want        = module.main.name
  }
}
