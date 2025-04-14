################################################################################
# RESOURCE GROUP MODULE OUTPUTS 
################################################################################

output "resource_group_id" {
  description = "Resource group generated id"
  value       = module.rg.resource_group_id
}

output "resource_group_name" {
  description = "Resource group generated id"
  value       = module.rg.resource_group_name
}

output "resource_id" {
  description = "acr resource id"
  value       = module.avm-res-containerregistry-registry.resource_id
}

output "resource_group_location" {
  description = "Resource group generated id"
  value       = module.rg.resource_group_location
}

output "container_registry_name" {
  value       = module.avm-res-containerregistry-registry.name
  description = "name of the container registry"
}

output "vnet_subnets" {
  description = "vnet subnet id"
  value       = module.vnet.vnet_subnets
}

output "vnet_name" {
  value       = module.vnet.vnet_name
  description = "name of virtual network."
}

output "vnet_location" {
  value       = module.vnet.vnet_location
  description = "location of virtual network."
}