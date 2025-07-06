# Outputs file
output "resource_group_name" {
  value       = azurerm_resource_group.hub_rg.name
  description = "Resource group name of this hub-spoke project"
}

output "nva_private_ip" {
  value       = azurerm_network_interface.nva_nic.private_ip_address
  description = "Private IP address of the NVA virtual appliance"
}

output "dns_server_private_ip" {
  value       = azurerm_network_interface.dns_nic.private_ip_address
  description = "Private IP address of the DNS server"
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hub_vnet.name
  description = "Name of the Hub virtual network"
}

output "public_ip" {
  value       = azurerm_public_ip.firewall_pip.id
  description = "Firewall Public IP"
}

output "vpn_gateway_public_ip1" {
  value = azurerm_public_ip.vpn_gw_public_ip1.ip_address
}

output "vpn_gateway_public_ip2" {
  value = azurerm_public_ip.vpn_gw_public_ip2.ip_address
}
