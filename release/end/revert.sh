#!/bin/bash
set -x

# Load the config file with our environmental variables

source "/etc/libvirt/hooks/kvm.conf"

# Unload VFIO-PCI Kernel Driver

modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Re-Bind GPU to our display drivers
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_USB
virsh nodedev-reattach $VIRSH_GPU_SERIAL

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Re-Bind EFI-Framebuffer DO NOT UNCOMMET
# echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

modprobe amdgpu
modprobe snd_hda_intel

# Restart Display Manager
systemctl start sddm.service


