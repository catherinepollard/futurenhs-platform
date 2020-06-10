variable "environment" {
  description = "Namespace for all resources. Eg 'production' 'dev-jane'"
}

variable "location" {
  description = "Azure location"
}

output "resource_group_name" {
  value = azurerm_resource_group.platform.name
}
