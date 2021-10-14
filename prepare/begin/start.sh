#!/bin/bash

echo Start Script  > /home/haithem/Public/vmlog

# Helpful to read output when debugging

set -x

# Load the config file with our environmental variables

source "/etc/libvirt/hooks/kvm.conf"

echo loaded the kvm config >> /home/haithem/Public/vmlog

# Stop your display manager. If you're on kde it'll be sddm.service. Gnome users should use 'killall gdm-x-session' instead

systemctl stop sddm.service

echo stopped the display manager >> /home/haithem/Public/vmlog

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

echo vtconsole unbin >> /home/haithem/Public/vmlog

# Unbind EFI-Framebuffer -- DO NOT UNCOMMENT
# echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

#echo unbind efi-framebuffer  >> /home/haithem/Public/vmlog

# Avoid a race condition by waiting a couple of seconds. This can be calibrated to be shorter or longer if required for your system
sleep 5


modprobe -r amdgpu
modprobe -r snd_hda_intel

echo unloaded the driver >> /home/haithem/Public/vmlog

#Unbind the GPU from display driver
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_GPU_USB
virsh nodedev-detach $VIRSH_GPU_SERIAL

echo unbind the virsh gpu  >> /home/haithem/Public/vmlog

# Load VFIO kernel module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

echo unloaded vfio kernel  >> /home/haithem/Public/vmlog


