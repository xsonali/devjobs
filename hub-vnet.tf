# Resource group name
resource "azurerm_resource_group" "hub_rg" {
  name     = "${var.resource_group_name_prefix}-hub-${random_string.suffix.result}"
  location = var.location
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

# Virtual network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = ["10.0.0.0/16"] # fixed typo here

  tags = {
    environment = "dev"
    owner       = "Gholam"
    project     = "hub-spoke"
  }
}

# Gateway subnet
resource "azurerm_subnet" "hub_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/27"]
}
# Firewall Subnet
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.2.0/26"]
}

# DNS Subnet for private name resolution
resource "azurerm_subnet" "dns_subnet" {
  name                 = "DNSSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.3.0/27"]
}

# Virtual network appliance 
resource "azurerm_subnet" "nva_subnet" {
  name                 = "nvasubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.4.0/27"]
}

# Network Interface for NVA VM
resource "azurerm_network_interface" "nva_nic" {
  name                = "nva-nic"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_forwarding_enabled = true


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.nva_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.4.4"

  }
}

# NIC for DNS Server
resource "azurerm_network_interface" "dns_nic" {
  name                = "dns-nic"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_configuration {
    name                          = "dns_ip"
    subnet_id                     = azurerm_subnet.dns_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.4"
  }
}

# VPN Gateway
resource "azurerm_virtual_network_gateway" "hub_vpn_gw" {
  name                = "hub-vpn-gateway"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased" # Needed for P2S and most modern scenarios
  active_active       = true
  enable_bgp          = false
  sku                 = "VpnGw1" # Choose based on performance/cost needs

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_public_ip1.id
    private_ip_address_allocation = "Dynamic" # This must be Dynamic, even for Standard SKU
    subnet_id                     = azurerm_subnet.hub_gateway_subnet.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_public_ip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway_subnet.id
  }
  tags = {
    environment = "hub-spoke"
    managed_by  = "terraform"
    created_by  = "Gholam"
  }
}

resource "azurerm_public_ip" "vpn_gw_public_ip1" {
  name                = "vpn-gateway-pip1"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "vpn_gw_public_ip2" {
  name                = "vpn-gateway-pip2"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}



