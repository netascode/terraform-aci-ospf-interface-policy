module "aci_ospf_interface_policy" {
  source  = "netascode/ospf-interface-policy/aci"
  version = ">= 0.0.1"

  tenant                  = "ABC"
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
