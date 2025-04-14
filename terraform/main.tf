################################################################################
# PROVIDER CONFIGURATION
################################################################################

provider "azurerm" {
  features {
  }
}

locals {
  common_tags = var.common_tags
}

################################################################################
# RESOURCE GROUP 
################################################################################

module "rg" {
  source               = "claranet/rg/azurerm"
  version              = "6.1.1"
  client_name          = var.client_name
  environment          = var.environment
  location             = var.location
  stack                = var.stack
  custom_rg_name       = var.custom_rg_name
  default_tags_enabled = var.default_tags_enabled
  lock_level           = var.lock_level
  extra_tags           = merge(local.common_tags, var.tags)
}

################################################################################
# AZURE VIRTUAL NETWORK
################################################################################

module "vnet" {
  source                   = "Azure/vnet/azurerm"
  version                  = "4.1.0"
  vnet_name                = var.vnet_name
  resource_group_name      = module.rg.resource_group_name
  vnet_location            = var.location
  use_for_each             = var.use_for_each
  address_space            = var.address_space
  bgp_community            = var.bgp_community
  dns_servers              = var.dns_servers
  nsg_ids                  = var.nsg_ids
  route_tables_ids         = var.route_tables_ids
  subnet_delegation        = var.subnet_delegation
  subnet_names             = var.subnet_names
  ddos_protection_plan     = var.ddos_protection_plan
  subnet_prefixes          = var.subnet_prefixes
  subnet_service_endpoints = var.subnet_service_endpoints
  tags                     = merge(local.common_tags, var.tags)
  depends_on               = [module.rg]
}

################################################################################
# AZURE CONTAINER REGISTRY
################################################################################

module "avm-res-containerregistry-registry" {
  source                        = "Azure/avm-res-containerregistry-registry/azurerm"
  version                       = "0.1.0"
  name                          = var.name
  resource_group_name           = module.rg.resource_group_name
  admin_enabled                 = var.admin_enabled
  anonymous_pull_enabled        = var.anonymous_pull_enabled
  data_endpoint_enabled         = var.sku == "Premium" ? true : false
  diagnostic_settings           = var.diagnostic_settings
  enable_telemetry              = var.enable_telemetry
  export_policy_enabled         = var.export_policy_enabled
  georeplications               = var.georeplications
  location                      = var.location
  lock                          = var.lock
  network_rule_bypass_option    = var.network_rule_bypass_option
  network_rule_set              = var.network_rule_set
  private_endpoints             = var.private_endpoints
  public_network_access_enabled = var.public_network_access_enabled
  sku                           = var.sku
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  tags                          = merge(local.common_tags, var.tags)
  depends_on                    = [module.vnet]
}

################################################################################
# AZURE KUBERNETES SERVICE
################################################################################

module "aks" {
  source                                      = "Azure/aks/azurerm"
  version                                     = "8.0.0"
  count                                       = length(var.aks_cluster_configs)
  resource_group_name                         = module.rg.resource_group_name
  location                                    = var.location
  agents_availability_zones                   = var.aks_cluster_configs[count.index].agents_availability_zones
  agents_count                                = var.aks_cluster_configs[count.index].agents_count
  agents_max_count                            = var.aks_cluster_configs[count.index].agents_max_count
  agents_max_pods                             = var.aks_cluster_configs[count.index].agents_max_pods
  agents_min_count                            = var.aks_cluster_configs[count.index].agents_min_count
  agents_size                                 = var.aks_cluster_configs[count.index].agents_size
  agents_pool_max_surge                       = var.aks_cluster_configs[count.index].agents_pool_max_surge
  agents_pool_name                            = var.aks_cluster_configs[count.index].agents_pool_name
  prefix                                      = var.aks_cluster_configs[count.index].prefix
  network_plugin                              = var.aks_cluster_configs[count.index].network_plugin
  brown_field_application_gateway_for_ingress = var.aks_cluster_configs[count.index].brown_field_application_gateway_for_ingress
  rbac_aad                                    = var.aks_cluster_configs[count.index].rbac_aad
  rbac_aad_managed                            = var.aks_cluster_configs[count.index].rbac_aad_managed
  role_based_access_control_enabled           = var.aks_cluster_configs[count.index].role_based_access_control_enabled
  rbac_aad_azure_rbac_enabled                 = var.aks_cluster_configs[count.index].rbac_aad_azure_rbac_enabled
  rbac_aad_admin_group_object_ids             = var.aks_cluster_configs[count.index].rbac_aad_admin_group_object_ids
  rbac_aad_tenant_id                          = var.aks_cluster_configs[count.index].rbac_aad_tenant_id
  cluster_name                                = var.aks_cluster_configs[count.index].cluster_name
  enable_auto_scaling                         = var.aks_cluster_configs[count.index].enable_auto_scaling
  key_vault_secrets_provider_enabled          = var.aks_cluster_configs[count.index].key_vault_secrets_provider_enabled
  oidc_issuer_enabled                         = var.aks_cluster_configs[count.index].oidc_issuer_enabled
  secret_rotation_enabled                     = var.aks_cluster_configs[count.index].secret_rotation_enabled
  secret_rotation_interval                    = var.aks_cluster_configs[count.index].secret_rotation_interval
  kubernetes_version                          = var.aks_cluster_configs[count.index].kubernetes_version
  node_pools                                  = var.aks_cluster_configs[count.index].node_pools
  attached_acr_id_map                         = { "acr" = module.avm-res-containerregistry-registry.resource_id } //connect above acr with aks by passing its resource id
  monitor_metrics                             = var.aks_cluster_configs[count.index].monitor_metrics
  sku_tier                                    = var.aks_cluster_configs[count.index].sku_tier
  node_resource_group                         = var.aks_cluster_configs[count.index].node_resource_group
  os_disk_size_gb                             = var.aks_cluster_configs[count.index].os_disk_size_gb
  pod_subnet_id                               = var.aks_cluster_configs[count.index].pod_subnet_id
  local_account_disabled                      = var.aks_cluster_configs[count.index].local_account_disabled
  vnet_subnet_id                              = var.aks_cluster_configs[count.index].vnet_subnet_id
  log_analytics_workspace_enabled             = var.aks_cluster_configs[count.index].log_analytics_workspace_enabled
  cluster_log_analytics_workspace_name        = var.aks_cluster_configs[count.index].cluster_log_analytics_workspace_name
  tags                                        = merge(local.common_tags, var.tags)
  depends_on                                  = [module.avm-res-containerregistry-registry, module.vnet]
}

