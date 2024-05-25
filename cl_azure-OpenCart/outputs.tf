#output "terraform_identity_object_id" {
#  value = azurerm_user_assigned_identity.terraform.principal_id
#}
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "public_ip_address_web_server" {
  value = azurerm_linux_virtual_machine.DStoeckm-vm.public_ip_address
}

// output of my terterraform execution public IP
output "my_public_ip" {
  value = "${data.external.myipaddr.result.ip}"
}
// output "public_ip_address" {
//   description = "The actual ip address allocated for the resource."
//   value       = data.azurerm_public_ip.DStoeckm-public_ip
// }
// output "private_ips" {
//   value = { for vm in var.vm_name : vm => azurerm_linux_virtual_machine.DStoeckm-vm[vm].private_ip_address }
// }
// output "tls_private_key" {
//   value     = tls_private_key.example_ssh.private_key_pem
//   sensitive = true
// }