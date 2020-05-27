resource "azurerm_public_ip" "dev_ip" {
  name                = "platform-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "cluster" {
  name                 = var.cluster_subnet_name
  resource_group_name  = var.vnet_resource_group
  address_prefixes     = ["10.0.0.0/26"]
  virtual_network_name = var.vnet_name
}
