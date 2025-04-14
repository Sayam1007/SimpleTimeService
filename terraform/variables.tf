################################################################################
# RESOURCE GROUP MODULE VARIABLES 
################################################################################

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
  default     = null
}

variable "environment" {
  description = "Project environment."
  type        = string
  default     = null
}

variable "location" {
  description = "location of resource group"
  type        = string
  default     = "centralindia"
}

variable "stack" {
  description = "Project stack name."
  type        = string
  default     = null
}

variable "custom_rg_name" {
  description = "custom name of resource group"
  type        = string
  default     = "motori-rg-staging"
}

variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Specifies the Level to be used for this RG Lock. Possible values are Empty (no lock), `CanNotDelete` and `ReadOnly`"
  type        = string
  default     = ""
}

################################################################################
# VNET MODULE VARIABLES 
################################################################################

variable "vnet_name" {
  description = "Name of the vnet to create."
  type        = string
  default     = "vnet1"
}

variable "use_for_each" {
  description = "Use `for_each` instead of `count` to create multiple resource instances"
  type        = bool
  default     = false
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
  default     = []
}

variable "bgp_community" {
  description = "(Optional) The BGP community attribute in format `<as-number>:<community-value>`."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)
  default     = {}
}

variable "ddos_protection_plan" {
  type = object({
    enable = bool
    id     = string
  })
  description = <<EOD
The DDoS protection plan configuration with the following attributes:
- enable: A boolean flag to indicate whether the DDoS protection plan is enabled.
- id: The ID of the DDoS protection plan.
EOD
  default     = null
}

variable "route_tables_ids" {
  description = "A map of subnet name to Route table ids"
  type        = map(string)
  default     = {}
}

variable "subnet_delegation" {
  description = "A map of subnet name to delegation block on the subnet"
  type        = map(map(any))
  default = {
    # "app-service" = {
    #   "service_delegation" = {
    #     "service_name" = "Microsoft.Web/serverFarms"
    #     // Optionally include service_actions if needed
    #     "service_actions" = []
    #   }
    # }
  }
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = ["subnet1"]
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common Tags for every resource being created"
}

variable "tags" {
  description = "The required tags for storage resource"
  type        = map(string)
  default     = {}
}

################################################################################
# CONTAINER REGISTRY MODULE VARIABLES
################################################################################

variable "name" {
  description = "The name of the Container Registry."
  type        = string
  default     = "acrmtrmgmt"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled. Defaults to `true`."
  type        = bool
  default     = true
}

variable "anonymous_pull_enabled" {
  description = "Specifies whether anonymous (unauthenticated) pull access to this Container Registry is allowed. Requries Standard or Premium SKU."
  type        = bool
  default     = false
}

variable "data_endpoint_enabled" {
  description = "Specifies whether to enable dedicated data endpoints for this Container Registry. Requires Premium SKU."
  type        = bool
  default     = false
}

variable "diagnostic_settings" {
  description = "A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources. - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`. - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `[allLogs]`. - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to [AllMetrics]. - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`. - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to. - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to. - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to. - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected. - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs."
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default = {}
}

variable "enable_telemetry" {
  description = "This variable controls whether or not telemetry is enabled for the module. For more information see https://aka.ms/avm/telemetryinfo. If it is set to false, then no telemetry will be collected."
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "Specifies whether export policy is enabled. Defaults to true. In order to set it to false, make sure the public_network_access_enabled is also set to false."
  type        = bool
  default     = true
}

variable "georeplications" {
  description = "A list of geo-replication configurations for the Container Registry. - `location` - (Required) The geographic location where the Container Registry should be geo-replicated. - `regional_endpoint_enabled` - (Optional) Enables or disables regional endpoint. Defaults to `true`. - `zone_redundancy_enabled` - (Optional) Enables or disables zone redundancy. Defaults to `true`. - `tags` - (Optional) A map of additional tags for the geo-replication configuration. Defaults to `null`."
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool, true)
    zone_redundancy_enabled   = optional(bool, true)
    tags                      = optional(map(any), null)
  }))
  default = []
}

variable "lock" {
  description = "The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."
  type = object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
  default = {}
}

variable "network_rule_bypass_option" {
  description = " Specifies whether to allow trusted Azure services access to a network restricted Container Registry. Possible values are `None` and `AzureServices`. Defaults to `None`"
  type        = string
  default     = "AzureServices"
}

variable "network_rule_set" {
  description = "The network rule set configuration for the Container Registry. Requires Premium SKU. - `default_action` - (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`. - `ip_rules` - (Optional) A list of IP rules in CIDR format. Defaults to `[]`. - `action` - Only Allow is permitted - `ip_range` - The CIDR block from which requests will match the rule. - `virtual_network` - (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Container Registry. Defaults to `[]`. - `action` - Only Allow is permitted - `subnet_id` - The subnet id from which requests will match the rule."
  type = object({
    default_action = optional(string, "Deny")
    ip_rule = optional(list(object({
      action = optional(string, "Allow")
    ip_range = string })), [])
    virtual_network = optional(list(object({
      action    = optional(string, "Allow")
      subnet_id = string
      })),
    [])
  })
  default = null
}

variable "private_endpoints" {
  description = "A map of private endpoints to create on this resource."
  type = map(object({
    name = optional(string)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
    })))
    lock = optional(object({
      name = optional(string)
      kind = optional(string, "None")
    }))
    tags                                    = optional(map(any))
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_resource_ids = optional(map(string), {})
    private_service_connection_name         = optional(string)
    network_interface_name                  = optional(string)
    location                                = optional(string)
    resource_group_name                     = optional(string)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
      subresource_name   = optional(string)
      member_name        = optional(string)
    })))
  }))
  default = {}
}

variable "public_network_access_enabled" {
  description = "is public access enabled ?"
  type        = bool
  default     = false
}

variable "quarantine_policy_enabled" {
  description = "Specifies whether the quarantine policy is enabled."
  type        = bool
  default     = false
}

variable "sku" {
  description = "The SKU name of the Container Registry. Default is `Premium`. `Possible values are `Basic`, `Standard` and `Premium`."
  type        = string
  default     = "Premium"
}

variable "zone_redundancy_enabled" {
  description = "Specifies whether zone redundancy is enabled. Modifying this forces a new resource to be created."
  type        = bool
  default     = false
}

################################################################################
# AKS MODULE VARIABLES 
################################################################################

variable "aks_cluster_configs" {
  description = "List of AKS cluster configurations"
  type = list(object({
    agents_availability_zones = list(string)
    agents_count              = number
    agents_max_count          = number
    agents_max_pods           = number
    agents_min_count          = number
    agents_size               = string
    agents_pool_max_surge     = string
    agents_pool_name          = string
    prefix                    = string
    network_plugin            = string
    brown_field_application_gateway_for_ingress = optional(object({
      id        = string
      subnet_id = string
    }))
    rbac_aad                           = bool
    rbac_aad_managed                   = bool
    role_based_access_control_enabled  = bool
    rbac_aad_azure_rbac_enabled        = bool
    rbac_aad_admin_group_object_ids    = list(string)
    rbac_aad_tenant_id                 = string
    cluster_name                       = string
    enable_auto_scaling                = bool
    key_vault_secrets_provider_enabled = bool
    oidc_issuer_enabled                = bool
    secret_rotation_enabled            = bool
    secret_rotation_interval           = string
    kubernetes_version                 = string
    node_pools = map(object({
      name                          = string
      node_count                    = optional(number)
      tags                          = optional(map(string))
      vm_size                       = string
      host_group_id                 = optional(string)
      capacity_reservation_group_id = optional(string)
      custom_ca_trust_enabled       = optional(bool)
      enable_auto_scaling           = optional(bool)
      enable_host_encryption        = optional(bool)
      enable_node_public_ip         = optional(bool)
      eviction_policy               = optional(string)
      gpu_instance                  = optional(string)
      kubelet_config = optional(object({
        cpu_manager_policy        = optional(string)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        topology_manager_policy   = optional(string)
        allowed_unsafe_sysctls    = optional(set(string))
        container_log_max_size_mb = optional(number)
        container_log_max_files   = optional(number)
        pod_max_pid               = optional(number)
      }))
      linux_os_config = optional(object({
        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(bool)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
        transparent_huge_page_enabled = optional(string)
        transparent_huge_page_defrag  = optional(string)
        swap_file_size_mb             = optional(number)
      }))
      fips_enabled       = optional(bool)
      kubelet_disk_type  = optional(string)
      max_count          = optional(number, 80)
      max_pods           = optional(number)
      message_of_the_day = optional(string)
      mode               = optional(string)
      min_count          = optional(number, 1)
      node_network_profile = optional(object({
        node_public_ip_tags = optional(map(string))
      }))
      node_labels                  = optional(map(string))
      node_public_ip_prefix_id     = optional(string)
      node_taints                  = optional(list(string))
      orchestrator_version         = optional(string)
      os_disk_size_gb              = optional(number)
      os_disk_type                 = optional(string, "Managed")
      os_sku                       = optional(string)
      os_type                      = optional(string, "Linux")
      pod_subnet_id                = optional(string)
      priority                     = optional(string, "Regular")
      proximity_placement_group_id = optional(string)
      spot_max_price               = optional(number)
      scale_down_mode              = optional(string, "Delete")
      snapshot_id                  = optional(string)
      ultra_ssd_enabled            = optional(bool)
      vnet_subnet_id               = optional(string)
      upgrade_settings = optional(object({
        max_surge = string
      }))
      windows_profile = optional(object({
        outbound_nat_enabled = optional(bool, true)
      }))
      workload_runtime      = optional(string)
      zones                 = optional(set(string))
      create_before_destroy = optional(bool, true)
    }))
    monitor_metrics = object({
      annotations_allowed = optional(string, null)
      labels_allowed      = optional(string, null)
    })
    sku_tier                             = string
    node_resource_group                  = string
    os_disk_size_gb                      = number
    pod_subnet_id                        = string
    local_account_disabled               = bool
    vnet_subnet_id                       = string
    log_analytics_workspace_enabled      = bool
    cluster_log_analytics_workspace_name = string
    msi_auth_for_monitoring_enabled      = bool
  }))
  default = []
}