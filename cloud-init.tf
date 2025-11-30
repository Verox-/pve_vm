resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
      hostname            = var.vm_name
      username            = var.cloud_init_username
      hashed_password     = var.cloud_init_hashed_password
      ssh_public_key      = var.cloud_init_ssh_public_key
      timezone            = var.cloud_init_timezone
      ssh_password_auth   = var.cloud_init_ssh_password_auth
      custom_packages     = var.cloud_init_custom_packages
      custom_write_files  = var.cloud_init_custom_write_files
      custom_runcmd       = var.cloud_init_custom_runcmd
    })

    file_name = "cloud-config-${var.vm_name}.yaml"
  }
}
