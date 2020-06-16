output "resource_group_name" {
  value = azurerm_resource_group.platform.name
}

output "cluster_identity_principal_id" {
  value = azurerm_kubernetes_cluster.cluster.kubelet_identity.0.object_id
}
