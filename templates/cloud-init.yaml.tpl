#cloud-config
timezone: ${timezone}
hostname: ${hostname}

# config users
users:
  - default
  - name: ${username}
    sudo:  "ALL=(ALL) NOPASSWD:ALL"
    passwd: ${hashed_password}
    lock_passwd: false
    ssh_authorized_keys:
      - ${ssh_public_key}

# simple hardening
ssh_pwauth: ${ssh_password_auth}
disable_root: true

# config packages
package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent
  - fail2ban
  - unattended-upgrades
%{ for pkg in custom_packages ~}
  - ${pkg}
%{ endfor ~}

# Automatic security updates
write_files:
  - path: /etc/apt/apt.conf.d/50unattended-upgrades
    content: |
      Unattended-Upgrade::Automatic-Reboot "false";
      Unattended-Upgrade::Remove-Unused-Dependencies "true";
      Unattended-Upgrade::Automatic-Reboot-Time "03:00";
%{ for file in custom_write_files }
  - path: ${file.path}
    permissions: '${file.permissions}'
    owner: ${file.owner}
    content: |
      ${indent(6, file.content)}
%{ endfor }

# Final system config
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - systemctl start fail2ban
  - systemctl enable fail2ban
  - systemctl enable unattended-upgrades
%{ for cmd in custom_runcmd ~}
  - ${cmd}
%{ endfor ~}
  - echo "done" > /tmp/cloud-config.done

final_message: "Cloud-init finished. System ready."
