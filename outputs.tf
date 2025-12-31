output "vm_ips" {
  value = module.vm.vm_ips
}

output "control_plane_ip" {
    value = module.vm.vm_cp_ip
}

output "bastion_ip" {
    value = module.vm.vm_bastion_ip
}

output "floating_ips" {
  value = module.vm.floating_ips
}