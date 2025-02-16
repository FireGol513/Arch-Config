#!/bin/bash

#All executed commands are printed to the terminal
set -x

#Initial ramdisk ?
mkinitcpio -P 

#Set the time zone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#Set the hardware clock to UTC
hwclock -wu

#Install a CLI text editor
pacman -S vim --no-confirm

#Uncomment en_US.UTF-8 UTF-8 and ca_FR.UTF-8 UTF-8 in /etc/locale.gen
cat /etc/locale.gen | sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' -e 's/#ca_FR.UTF-8 UTF-8/ca_FR.UTF-8 UTF-8/' > /tmp/locale.gen
cp /tmp/locale.gen /etc/locale.gen

#Generated the locale (what we uncomment before)
locale-gen

#Default keyboard language when boot
echo LANG=en_US.UTF-8 > /etc/locale.conf

#Temporary put default keyboard language for continue the config
export LANG=en_US.UTF-8

#Create my main user
useradd -m -g users -G wheel,power,storage firegol513 -s /bin/bash

#Change my main user password
echo 'Write my main user password'
passwd firegol513

#Change my root password
echo 'Write my root password'
passwd

#Hostname of the computer
echo arch-firepc > /etc/hostname

#Installation of grub (bootmgr)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable

#Configuration of grub when we boot
grub-mkconfig -o /boot/grub/grub.cfg

#Initial ramdisk ?
mkinitcpio -P

#Extend life of SSD?
systemctl enable fstrim.timer

#Network Configuration (Need to use it more)
systemctl enable NetworkManager

#Simple Time protocol client (SNTP not NTP)
systemctl enable systemd-timesyncd

#Uncomment multilib (Include = /etc/pacman.d/mirrorlist) in /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

#NVIDIA?
#

#
pacman -S linux-headers git base-devel intel-ucode nvidia nvidia-settings opencl-nvidia nvidia-utils vulkan-icd-loader #Probably in a other script

#Uncomment in visudo the %wheel + Defaults rootpw + Defaults insults
sed -i "# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
sed -i "s/# Defaults targetpw /Defaults rootpw/" /etc/sudoers
echo "Defaults insults" >> /etc/sudoers


#In /etc/mkinitcpio.conf, add nvidia nvidia_modeset nvidia_uvm nvidia_drm to MODULES and remove kms from HOOKS



#Add nvidia pacman hook to /etc/pacman.d/hooks/nvidia.hook

#[Trigger]
#Operation=Install
#Operation=Upgrade
#Operation=Remove
#Type=Package
# Uncomment the installed NVIDIA package
#Target=nvidia
#Target=nvidia-open
#Target=nvidia-lts
# If running a different kernel, modify below to match
#Target=linux

#[Action]
#Description=Updating NVIDIA module in initcpio
#Depends=mkinitcpio
#When=PostTransaction
#NeedsTargets
#Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'

#Next steps
#Copy the repo somewhere (all this files)
#Run script for terminal
pacman -S sddm hyprland waybar #Probably in a other script
pacman -S pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber #Probably in a other script
systemctl enable sddm
yay -Syu librewolf-bin rofi-lbonn-wayland 
#Change keybinds in ~/.config/hypr/hyprland.conf

#Virtualisation 
#Death part ;D
LC_ALL=C lscpu | grep Virtualization
zgrep CONFIG_KVM= /proc/config.gz #Only works if y or m
lsmod | grep kvm #Check if kvm and kvm_intel are there
pacman -S qemu-full libvirt virt-manager dnsmasq iptables-nft openbsd-netcat
usermod -aG libvirt firegol513
systemctl enable libvirtd virtlogd