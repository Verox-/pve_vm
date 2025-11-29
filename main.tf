resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  description = var.description
  tags = var.vm_tags
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
    file_id      = var.cloud_image_file_id != null ? var.cloud_image_file_id : data.proxmox_virtual_environment_file.cloud_image[0].id
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

# Validation to ensure either cloud_image_file_id or cloud_image_name is provided
locals {
  has_cloud_image = (var.cloud_image_file_id != null) || (var.cloud_image_name != null)
}

resource "null_resource" "validate_cloud_image" {
  lifecycle {
    precondition {
      condition     = local.has_cloud_image
      error_message = "Either 'cloud_image_file_id' or 'cloud_image_name' must be provided."
    }
  }
}
