resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name    = "pve"
  
  # VM specs
  cpu {
    cores = var.vm_cores
    type  = "host"
  }
  
  memory {
    dedicated = var.vm_mem
  }
  
  # Storage
  disk {
    datastore_id = "local-zfs"
    file_id      = var.cloud_image_file_id
    interface    = "scsi0"
    size         = var.vm_disk_size
  }
  
  # Network
  network_device {
    bridge = "vmbr1v300"
    model  = "virtio"
  }
  
  # Cloud-init settings
  initialization {
    datastore_id = "local-zfs" 
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
  
  # Enable QEMU guest agent
  agent {
    enabled = true
  }
  
  # Wait for cloud-init to complete
  operating_system {
    type = "l26"  # Linux kernel 2.6+
  }
}
