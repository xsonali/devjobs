# Private DNS Zone
resource "azurerm_private_dns_zone" "austra_internal" {
  name                = "austra.internal"
  resource_group_name = azurerm_resource_group.hub_rg.name
  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

# Link Private DNS Zone to hub VNet
resource "azurerm_private_dns_zone_virtual_network_link" "hub_vnet_link" {
  name                  = "hub-vnet-link"
  resource_group_name   = azurerm_resource_group.hub_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.austra_internal.name
  virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  registration_enabled  = true

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

# Link Private DNS Zone to spoke1 VNet
resource "azurerm_private_dns_zone_virtual_network_link" "spoke1_vnet_link" {
  name                  = "spoke1-vnet-link"
  resource_group_name   = azurerm_resource_group.hub_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.austra_internal.name
  virtual_network_id    = azurerm_virtual_network.spoke1_vnet.id
  registration_enabled  = false

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}
