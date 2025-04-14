################################################################################
# COMMON VARIABLES 
################################################################################

location = "eastus"
# resource tags
tags = {
  terraform   = true
  project     = "SimpleTimeService"
  environment = "dev"
}

################################################################################
# AZURE RESOURCE GROUP
################################################################################

custom_rg_name = "rg-SimpleTimeService"

################################################################################
# AZURE VIRTUAL NETWORK
################################################################################

vnet_name                = "vnet-SimpleTimeService"
use_for_each             = false
dns_servers              = [] #dns server custom ip addresses for this vnet
address_space            = ["10.10.0.0/22"]
subnet_names             = ["default"]
subnet_prefixes          = ["10.10.0.0/22"]
subnet_service_endpoints = {}
ddos_protection_plan     = null

################################################################################
# AZURE CONTAINER REGISTRY
################################################################################

name                          = "acrsimpletimeservice" // acr name cannot contain special characters
public_network_access_enabled = true
admin_enabled                 = true
sku                           = "Standard"
network_rule_bypass_option    = "AzureServices"
zone_redundancy_enabled       = false
georeplications               = []

################################################################################
# AZURE KUBERNETES SERVICE
################################################################################

aks_cluster_configs = [
  {
    agents_availability_zones                   = []
    agents_count                                = null
    agents_max_count                            = 10
    agents_max_pods                             = null
    agents_min_count                            = 1
    agents_size                                 = "Standard_D2ads_v5"
    agents_pool_max_surge                       = "10%"
    agents_pool_name                            = "default"
    prefix                                      = "aks"
    network_plugin                              = "azure"
    brown_field_application_gateway_for_ingress = null
    rbac_aad                                    = false
    rbac_aad_managed                            = false
    role_based_access_control_enabled           = true
    rbac_aad_azure_rbac_enabled                 = false
    rbac_aad_admin_group_object_ids             = []
    rbac_aad_tenant_id                          = null
    cluster_name                                = "aks-SimpleTimeService"
    enable_auto_scaling                         = true
    key_vault_secrets_provider_enabled          = true
    oidc_issuer_enabled                         = true
    secret_rotation_enabled                     = true
    secret_rotation_interval                    = "2m"
    kubernetes_version                          = null
    node_pools                                  = {}
    monitor_metrics = {
    }
    sku_tier                             = "Standard"
    node_resource_group                  = null
    os_disk_size_gb                      = 30
    pod_subnet_id                        = null
    vnet_subnet_id                       = "/subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx/resourceGroups/rg-SimpleTimeService/providers/Microsoft.Network/virtualNetworks/vnet-SimpleTimeService/subnets/default"
    local_account_disabled               = false
    log_analytics_workspace_enabled      = false
    cluster_log_analytics_workspace_name = null
    msi_auth_for_monitoring_enabled      = true
  }
]