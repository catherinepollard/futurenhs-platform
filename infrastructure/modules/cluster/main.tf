resource "azurerm_public_ip" "dev_ip" {
  name                = "platform-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.USERNAME
  location            = var.REGION
  dns_prefix          = var.USERNAME
  resource_group_name = var.resource_group_name

  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    max_count           = 2
    min_count           = 1
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = var.vnet_subnet_id
    availability_zones  = ["1", "2", "3"]
    tags = {
      environment = "dev-${var.USERNAME}"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "kubenet"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }
    azure_policy {
      enabled = false
    }
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.cluster.id
    }
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_log_analytics_workspace" "cluster" {
  name                = "cluster-${var.USERNAME}"
  location            = var.REGION
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
  }
}
