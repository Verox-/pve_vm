variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_root_password" {
  description = "Proxmox root password for SSH access"
  type        = string
  sensitive   = true
}

variable "proxmox_node_name" {
  description = "Proxmox node name where VMs will be created"
  type        = string
  default     = "pve"
}

variable "cloud_image_file_id" {
  description = "File ID of the base image to use (optional if cloud_image_name is provided)"
  type        = string
  default     = null
}

variable "cloud_image_name" {
  description = "Name of pre-existing cloud image file on Proxmox (e.g., 'ubuntu-25.04-cloudimg-amd64.img'). Used when image is pre-downloaded to Proxmox."
  type        = string
  default     = null
}

variable "cloud_image_datastore" {
  description = "Datastore where the cloud image is located (used with cloud_image_name)"
  type        = string
  default     = "local"
}

variable "vm_name" {
  description = "Name for the VM"
  type        = string
  nullable = false
}

variable "description" {
  description = "Description for the VM"
  type        = string
  default     = ""
}

variable "vm_tags" {
  description = "Tags to apply to the VM"
  type        = list(string)
  default     = []
}

variable "vm_cores" {
  description = "Number of cores to assign to the VM"
  type        = number
  nullable   = false
}

variable "vm_mem" {
  description = "MB of RAM to assign to the VM"
  type        = number
  nullable     = false
}

variable "vm_disk_size" {
  description = "Disk size in GB for the VM"
  type        = number
  nullable   = false
  default     = 32
}

# Cloud-init configuration variables
variable "cloud_init_username" {
  description = "Username for the cloud-init user"
  type        = string
  default     = "verox"
}

variable "cloud_init_hashed_password" {
  description = "Hashed password for the cloud-init user"
  type        = string
  sensitive   = true
}

variable "cloud_init_ssh_public_key" {
  description = "SSH public key for the cloud-init user"
  type        = string
}

variable "cloud_init_timezone" {
  description = "Timezone for the VM"
  type        = string
  default     = "UTC"
}

variable "cloud_init_ssh_password_auth" {
  description = "Allow SSH password authentication"
  type        = bool
  default     = false
}

variable "cloud_init_custom_packages" {
  description = "Additional packages to install via cloud-init"
  type        = list(string)
  default     = []
}

variable "cloud_init_custom_write_files" {
  description = "Additional files to write via cloud-init (list of maps with path and content keys)"
  type        = list(object({
    path    = string
    content = string
    permissions = optional(string, "0644")
    owner   = optional(string, "root:root")
  }))
  default     = []
}

variable "cloud_init_custom_runcmd" {
  description = "Additional commands to run via cloud-init"
  type        = list(string)
  default     = []
}
