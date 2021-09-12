output "dn" {
  value       = aci_rest.ospfIfPol.id
  description = "Distinguished name of `ospfIfPol` object."
}

output "name" {
  value       = aci_rest.ospfIfPol.content.name
  description = "OSPF interface policy name."
}
