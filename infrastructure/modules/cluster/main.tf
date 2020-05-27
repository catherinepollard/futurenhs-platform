resource "azurerm_public_ip" "dev_ip" {
  name                = "platform-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}
