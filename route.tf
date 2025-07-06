# Route Table: GatewaySubnet → Spoke1 VNet
resource "azurerm_route_table" "rt_gateway_to_spoke1" {
  name                = "rt-gateway-to-spoke1"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  tags = {
    environment = "hub-spoke"
    managed_by  = "terraform"
    created_by  = "Gholam"
  }
}

resource "azurerm_route" "route_to_spoke1" {
  name                   = "to-spoke1"
  resource_group_name    = azurerm_resource_group.hub_rg.name
  route_table_name       = azurerm_route_table.rt_gateway_to_spoke1.name
  address_prefix         = "10.1.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.4.4" # IP of the NVA
}

resource "azurerm_subnet_route_table_association" "assoc_gateway_rt" {
  subnet_id      = azurerm_subnet.hub_gateway_subnet.id
  route_table_id = azurerm_route_table.rt_gateway_to_spoke1.id
}

# Route Table: Spoke Workload Subnet → GatewaySubnet + Internet
resource "azurerm_route_table" "rt_spoke1" {
  name                = "rt-spoke1"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

# Route to GatewaySubnet (return traffic)
resource "azurerm_route" "route_to_gateway" {
  name                   = "to-gateway"
  resource_group_name    = azurerm_resource_group.hub_rg.name
  route_table_name       = azurerm_route_table.rt_spoke1.name
  address_prefix         = "10.0.1.0/27"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.4.4"
}

# Default route to NVA for Internet-bound traffic
resource "azurerm_route" "route_to_internet" {
  name                   = "default-to-nva"
  resource_group_name    = azurerm_resource_group.hub_rg.name
  route_table_name       = azurerm_route_table.rt_spoke1.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.4.4"
}

resource "azurerm_subnet_route_table_association" "assoc_spoke1_rt" {
  subnet_id      = azurerm_subnet.workload_sn.id
  route_table_id = azurerm_route_table.rt_spoke1.id
}
