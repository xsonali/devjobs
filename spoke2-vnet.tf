# Define Spoke2 Virtual Network
resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = "spoke2-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = ["10.2.0.0/16"]

  tags = {
    environment = "dev"
    owner       = "Gholam"
    project     = "hub-spoke"
  }
}

# Left blank for future development