# Firewall Public IP
resource "azurerm_public_ip" "firewall_pip" {
  name                = "firewall-pip"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub_firewall" {
  name                = "hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

resource "azurerm_firewall_policy" "allow_msweb" {
  name                = "msweb-firewall-policy"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location

  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

resource "azurerm_firewall_application_rule_collection" "allow_microsoft" {
  name                = "AllowMicrosoftAccess"
  azure_firewall_name = azurerm_firewall.hub_firewall.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  priority            = 110
  action              = "Allow"

  rule {
    name             = "AllowMicrosoftSites"
    source_addresses = ["192.168.1.0/24"]

    protocol {
      port = 80
      type = "Http"
    }

    protocol {
      port = 443
      type = "Https"
    }

    target_fqdns = ["*.microsoft.com"]
  }
}


resource "azurerm_network_security_rule" "allow_rdp_from_192" {
  name                        = "allow-rdp-from-192"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "192.168.1.0/24"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.workload_nsg.name
  resource_group_name         = azurerm_resource_group.hub_rg.name
}
