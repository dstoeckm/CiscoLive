variable "resource_group_location" {
  default     = "GermanyWestCentral" // westeurope GermanyWestCentral
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "azurerm_resource_group" {
  default = "RG-DStoeckm"
  description = "default resource group for PLX demos"
}
variable "DeploymentName" {
  default = "DStoeckm"
  description = "default deployment name"
}
variable "centos-publisher" {
  type        = string
  description = "Publisher ID for CentOS Linux" 
  default     = "OpenLogic" 
}
variable "centos-offer" {
  type        = string
  description = "Offer ID for CentOS Linux" 
  default     = "CentOS" 
}

#variable "Db_firewall_ip" {
#  type = string
#  description = "public IP from VM"
#  default = "${azurerm_linux_virtual_machine.DStoeckm-vm.public_ip_address}"
#  
#}