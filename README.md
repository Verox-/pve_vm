# Proxmox VM Module

This Terraform module creates a Proxmox Virtual Environment VM with cloud-init configuration.

## Features

- ✅ Cloud-init configuration via templates
- ✅ Parameterized user configuration (username, password, SSH key)
- ✅ Automatic package updates and security hardening
- ✅ QEMU guest agent pre-installed
- ✅ fail2ban and unattended-upgrades configured
- ✅ Two methods for cloud images: pre-downloaded or Terraform-managed

## Usage

### Method 1: Pre-downloaded Cloud Image (Recommended for Multiple Repos)

**One-time setup on Proxmox:**
```bash
ssh root@pve
cd /var/lib/vz/template/iso
wget https://cloud-images.ubuntu.com/plucky/current/plucky-server-cloudimg-amd64.img
```

**Then in your Terraform:**
```hcl
data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_ed25519.pub")
}

module "my_vm" {
  source = "github.com/Verox-/pve_vm"

  # Proxmox credentials
  proxmox_api_token     = var.proxmox_api_token
  proxmox_root_password = var.proxmox_root_password

  # Reference pre-downloaded cloud image
  cloud_image_name = "ubuntu-25.04-cloudimg-amd64.img"

  # VM configuration
  vm_name      = "my-vm-01"
  vm_cores     = 4
  vm_mem       = 8192
  vm_disk_size = 32

  # Cloud-init configuration
  cloud_init_username        = "myuser"
  cloud_init_hashed_password = "$2a$12$..."
  cloud_init_ssh_public_key  = data.local_file.ssh_public_key.content
  cloud_init_timezone        = "Europe/London"
}
```

### Method 2: Terraform-Managed Cloud Image

```hcl
# Download the cloud image once in your root module
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = "pve"
  url                = "https://cloud-images.ubuntu.com/plucky/current/plucky-server-cloudimg-amd64.img"
  file_name          = "ubuntu-25.04-cloudimg-amd64.img"
  overwrite          = false
  checksum_algorithm = "sha256"
  checksum           = "0ee2bf0cff2a81d6003a1cd40cb066288c0546b42b3fff9a6df7f30cc7e2ac22"
}

data "local_file" "ssh_public_key" {
  filename = pathexpand("~/.ssh/id_ed25519.pub")
}

module "my_vm" {
  source = "github.com/Verox-/pve_vm"

  # Proxmox credentials
  proxmox_api_token     = var.proxmox_api_token
  proxmox_root_password = var.proxmox_root_password

  # Use Terraform-downloaded image
  cloud_image_file_id = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id

  # VM configuration
  vm_name      = "my-vm-01"
  vm_cores     = 4
  vm_mem       = 8192
  vm_disk_size = 32

  # Cloud-init configuration
  cloud_init_username        = "myuser"
  cloud_init_hashed_password = "$2a$12$..."
  cloud_init_ssh_public_key  = data.local_file.ssh_public_key.content
  cloud_init_timezone        = "Europe/London"
}
```

## Generating Hashed Passwords

To generate a hashed password:

```bash
# On Linux/WSL
mkpasswd --method=SHA-512

# Or using Python
python3 -c 'import crypt; print(crypt.crypt("yourpassword", crypt.mksalt(crypt.METHOD_SHA512)))'
```
