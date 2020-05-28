provider "azurerm" {
  version = "=2.11.0"
  features {}
}

provider "random" {
  version = "~> 2.2"
}

terraform {
  required_version = "0.12.25"
  backend "azurerm" {
    container_name = "tfstate"
    key            = "dev.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "platform" {
  name     = "platform-${var.USERNAME}"
  location = var.REGION

  tags = {
    environment = "dev-${var.USERNAME}"
  }
}

resource "azurerm_virtual_network" "platform" {
  name                = "platform-${var.USERNAME}"
  address_space       = ["10.0.0.0/8"]
  location            = var.REGION
  resource_group_name = azurerm_resource_group.platform.name
  tags = {
    environment = "dev-${var.USERNAME}"
  }
}

resource "azurerm_subnet" "cluster_nodes" {
  name                 = "cluster-nodes-${var.USERNAME}"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.240.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.USERNAME
  location            = var.REGION
  dns_prefix          = var.USERNAME
  resource_group_name = azurerm_resource_group.platform.name

  default_node_pool {
    name                = "default"
    enable_auto_scaling = true
    max_count           = 2
    min_count           = 1
    vm_size             = "Standard_D2_v2"
    vnet_subnet_id      = azurerm_subnet.cluster_nodes.id
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
    environment = "dev-${var.USERNAME}"
  }
}


resource "azurerm_log_analytics_workspace" "cluster" {
  name                = "cluster-${var.USERNAME}"
  location            = var.REGION
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "dev-${var.USERNAME}"
  }
}
