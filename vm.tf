# Linux VM as NVA
resource "azurerm_linux_virtual_machine" "nva_vm" {
  name                            = "nva-vm"
  resource_group_name             = azurerm_resource_group.hub_rg.name
  location                        = azurerm_resource_group.hub_rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_user
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_user
    public_key = file("${path.module}/keys/new_azure_key.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.nva_nic.id
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
  EOF
  )

  tags = {
    role        = "nva"
    environment = "hub-spoke"
  }
}

# DNS Windows Server
resource "azurerm_windows_virtual_machine" "dns_server" {
  name                = "dns-server"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  size                = var.vm_size
  admin_username      = var.admin_user
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.dns_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  # Custom data runs at first boot - base64 encoded PowerShell script
  custom_data = base64encode(<<-EOT
    <powershell>
    Install-WindowsFeature DNS -IncludeManagementTools
    </powershell>
  EOT
  )

  tags = {
    role        = "dns"
    environment = "hub-spoke"
  }
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "workload_vm" {
  name                = "workload-vm"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  size                = var.vm_size
  admin_username      = var.admin_user
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.workload_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = "dev"
    owner       = "Gholam"
    project     = "hub-spoke"
  }
}



