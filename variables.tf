variable "location" {
  type        = string
  default     = "australiaeast"
  description = "Azure region where resources will be deployed"
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = <<EOT
Prefix for naming the resource group. A random string will be added 
to ensure uniqueness within the Azure subscription.
EOT
}

variable "admin_user" {
  type        = string
  default     = "adminuser"
  description = "Username for virtual machines"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  default     = "$Shampore321x"
  description = "Password for virtual machines"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "Size/SKU of the virtual machines"
}
