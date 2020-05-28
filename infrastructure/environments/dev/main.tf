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

# Create virtual network
resource "azurerm_virtual_network" "platform" {
  name                = "platform-${var.USERNAME}"
  address_space       = ["10.0.0.0/16"]
  location            = var.REGION
  resource_group_name = azurerm_resource_group.platform.name
}

# Create subnet
resource "azurerm_subnet" "cluster-nodes" {
  name                 = "cluster-nodes-${var.USERNAME}"
  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = azurerm_virtual_network.platform.name
  address_prefixes     = ["10.0.0.0/26"]
}
