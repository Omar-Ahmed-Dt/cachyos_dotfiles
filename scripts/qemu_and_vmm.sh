#!/bin/bash

# https://wiki.cachyos.org/virtualization/qemu_and_vmm_setup/
#

#!/bin/bash

sudo pacman -S qemu-full virt-manager swtpm

echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf

sudo usermod -aG libvirt $USER

# Start libvirt WITHOUT default network
sudo systemctl enable --now libvirtd.service

# Optional firewall rule
sudo ufw route allow from 192.168.122.0/24
