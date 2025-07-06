# NSG for NVA NIC
resource "azurerm_network_security_group" "nva_nsg" {
  name                = "nva-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # Or restrict to your IP: "203.0.113.5/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Spoke-To-NVA"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.1.0.0/16" # your spoke subnet or on-prem
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Return-Traffic"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Subnet association of nva_nsg
resource "azurerm_subnet_network_security_group_association" "nva_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.nva_subnet.id
  network_security_group_id = azurerm_network_security_group.nva_nsg.id
}

# NSG for DNS Server
resource "azurerm_network_security_group" "dns_nsg" {
  name                = "dns-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  security_rule {
    name                       = "allow-rdp-from-my-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "220.240.172.194" # Replace with your actual IP address
    destination_address_prefix = "*"
  }

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

# Subnet associaiton of dns_nsg
resource "azurerm_subnet_network_security_group_association" "dns_nsg_assoc" {
  subnet_id                 = azurerm_subnet.dns_subnet.id
  network_security_group_id = azurerm_network_security_group.dns_nsg.id
}

# NSG for workload NIC

resource "azurerm_network_security_group" "workload_nsg" {
  name                = "workload-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  security_rule {
    name                       = "allow-rdp-from-my-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "220.240.172.194"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

# Subnet associaiton of workload_nsg
resource "azurerm_network_interface_security_group_association" "workload_nic_assoc" {
  network_interface_id      = azurerm_network_interface.workload_nic.id
  network_security_group_id = azurerm_network_security_group.workload_nsg.id
}
