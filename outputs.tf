output "vm_ip" {
  value = proxmox_virtual_environment_vm.vm.ipv4_addresses[1][0]  # First non-loopback IP
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.vm.vm_id
}