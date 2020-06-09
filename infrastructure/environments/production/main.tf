provider "azurerm" {
  version = "=2.11.0"
  features {}
  subscription_id = "75173371-c161-447a-9731-f042213a19da"
}

provider "random" {
  version = "~> 2.2"
}

terraform {
  required_version = "0.12.25"
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "production.terraform.tfstate"
    resource_group_name  = "tfstate"
    storage_account_name = "fnhstfstateproduction"
  }
}

module platform {
  source      = "../../modules/platform"
  environment = "production"
  location    = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "fnhsproduction"
  resource_group_name = "platform-production"
  location            = var.location
  sku                 = "Basic"
}
