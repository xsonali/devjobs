# Spoke virtual network
resource "azurerm_virtual_network" "spoke1_vnet" {
  name                = "spoke1-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = "dev"
    owner       = "Gholam"
    project     = "hub-spoke"
  }
}

resource "azurerm_subnet" "workload_sn" {
  name                 = "workload-sn"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_network_interface" "workload_nic" {
  name                = "workload-nic"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.workload_sn.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.4"
  }
}
