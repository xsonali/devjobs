# Firewall Public IP
resource "azurerm_public_ip" "firewall_pip" {
  name                = "firewall-pip"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Firewall
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

  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id


  tags = {
    environment = "hub-spoke"
    created_by  = "Gholam"
  }
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "azfw_policy" {
  name                     = "azfw-policy"
  resource_group_name      = azurerm_resource_group.hub_rg.name
  location                 = azurerm_resource_group.hub_rg.location
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"

  dns {
    servers       = ["168.63.129.16"] # Azure default DNS
    proxy_enabled = true
  }
}

# Firewall Policy Rule Collection Group for Network Rules (RDP)
resource "azurerm_firewall_policy_rule_collection_group" "rdp_rule_group" {
  name               = "rdp-rule-group"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 110

  network_rule_collection {
    name     = "Allow-RDP"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "Allow-RDP-TCP"
      protocols             = ["TCP"]
      source_addresses      = ["192.168.1.0/24"]
      destination_addresses = ["10.1.0.0/24"]
      destination_ports     = ["3389"]
    }
  }
}

# Firewall Policy Rule Collection Group for DNAT
resource "azurerm_firewall_policy_rule_collection_group" "dnat_rule_group" {
  name               = "dnat-rule-group"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 100

  nat_rule_collection {
    name     = "DNAT-RDP"
    priority = 100
    action   = "Dnat"

    rule {
      name                = "DNAT-RDP-Rule"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.firewall_pip.ip_address
      destination_ports   = ["3389"]
      translated_address  = "10.1.0.4"
      translated_port     = "3389"
    }
  }
}

# Firewall Policy Rule Collection Group for Application Rules
# Firewall Policy Rule Collection Group for Application Rules
resource "azurerm_firewall_policy_rule_collection_group" "app_rule_group" {
  name               = "app-rule-group"
  firewall_policy_id = azurerm_firewall_policy.azfw_policy.id
  priority           = 120

  application_rule_collection {
    name     = "AllowMicrosoftAccess"
    priority = 100
    action   = "Allow"

    rule {
      name             = "AllowMicrosoftSites"
      source_addresses = ["192.168.1.0/24"]

      protocols {
        port = 80
        type = "Http"
      }

      protocols {
        port = 443
        type = "Https"
      }

      destination_fqdns = ["*.microsoft.com"]
    }
  }
}


