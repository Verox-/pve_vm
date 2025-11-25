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

variable "cloud_image_file_id" {
  description = "File ID of the base image to use"
  type        = string
}

variable "vm_name" {
  description = "Name for the VM"
  type        = string
  nullable = false
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
