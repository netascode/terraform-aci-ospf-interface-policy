terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                  = aci_rest.fvTenant.content.name
  name                    = "OSPF1"
  description             = "My Description"
  cost                    = "10"
  dead_interval           = 50
  hello_interval          = 15
  network_type            = "p2p"
  priority                = 10
  lsa_retransmit_interval = 10
  lsa_transmit_delay      = 3
  passive_interface       = true
  mtu_ignore              = true
  advertise_subnet        = true
  bfd                     = true
}

data "aci_rest" "ospfIfPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "ospfIfPol" {
  component = "ospfIfPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest.ospfIfPol.content.name
    want        = module.main.name
  }

  equal "cost" {
    description = "cost"
    got         = data.aci_rest.ospfIfPol.content.cost
    want        = "10"
  }

  equal "deadIntvl" {
    description = "deadIntvl"
    got         = data.aci_rest.ospfIfPol.content.deadIntvl
    want        = "50"
  }

  equal "helloIntvl" {
    description = "helloIntvl"
    got         = data.aci_rest.ospfIfPol.content.helloIntvl
    want        = "15"
  }

  equal "nwT" {
    description = "nwT"
    got         = data.aci_rest.ospfIfPol.content.nwT
    want        = "p2p"
  }

  equal "prio" {
    description = "prio"
    got         = data.aci_rest.ospfIfPol.content.prio
    want        = "10"
  }

  equal "rexmitIntvl" {
    description = "rexmitIntvl"
    got         = data.aci_rest.ospfIfPol.content.rexmitIntvl
    want        = "10"
  }

  equal "xmitDelay" {
    description = "xmitDelay"
    got         = data.aci_rest.ospfIfPol.content.xmitDelay
    want        = "3"
  }

  equal "ctrl" {
    description = "ctrl"
    got         = data.aci_rest.ospfIfPol.content.ctrl
    want        = "advert-subnet,bfd,mtu-ignore,passive"
  }
}
