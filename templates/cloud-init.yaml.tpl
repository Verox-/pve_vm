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

# Automatic security updates
write_files:
  - path: /etc/apt/apt.conf.d/50unattended-upgrades
    content: |
      Unattended-Upgrade::Automatic-Reboot "false";
      Unattended-Upgrade::Remove-Unused-Dependencies "true";
      Unattended-Upgrade::Automatic-Reboot-Time "03:00";

# Final system config
runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - systemctl start fail2ban
  - systemctl enable fail2ban
  - systemctl enable unattended-upgrades
  - echo "done" > /tmp/cloud-config.done

final_message: "Cloud-init finished. System ready."
