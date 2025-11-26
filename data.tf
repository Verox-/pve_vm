# Data source to reference pre-existing cloud image
data "proxmox_virtual_environment_file" "cloud_image" {
  count = var.cloud_image_name != null ? 1 : 0

  datastore_id = var.cloud_image_datastore
  node_name    = var.proxmox_node_name
  content_type = "iso"
  file_name    = var.cloud_image_name
}
