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
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}


resource "azurerm_resource_group" "platform" {
  name     = "rg-${var.USERNAME}"
  location = var.REGION

  tags = {
    environment = "dev-${var.USERNAME}"
  }
}

module cluster {
  source = "../../modules/cluster"

  # client_id                             = var.CLIENT_ID
  # client_secret                         = var.CLIENT_SECRET
  environment                           = "dev-${var.USERNAME}"
  location                              = var.REGION
  resource_group_name                   = azurerm_resource_group.platform.name
  # vnet_name                             = azurerm_virtual_network.cluster.name
  # vnet_resource_group                   = azurerm_virtual_network.cluster.resource_group_name
  # lb_subnet_id                          = azurerm_subnet.load_balancer.id
  # cluster_subnet_name                   = "adarz-spoke-products-sn-02"
  # cluster_subnet_cidr                   = "10.5.65.192/26"
  # cluster_route_destination_cidr_blocks = var.CLUSTER_ROUTE_DESTINATION_CIDR_BLOCKS
  # cluster_route_next_hop                = var.CLUSTER_ROUTE_NEXT_HOP
  # lb_route_table_id                     = azurerm_route_table.load_balancer.id
  # support_email_addresses               = var.SUPPORT_EMAIL_ADDRESSES
}
