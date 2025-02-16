#!/bin/zsh


##This script has the goal to Dual-Boot Windows and Arch-Linux on my GamingPC 
##This is the steps to achieve this


##Install Windows on a partition before install Arch

#All executed commands are printed to the terminal
set -x

#Change the timezone
timedatectl set-timezone America/New_York

#Make sure that keyring is up to date to prevent problem when install packages
pacman -Syy archlinux-keyring --no-confirm

#Install the basic package for the arch linux environnement
pacstrap -K /mnt base linux linux-firmware networkmanager grub efibootmgr sudo

#Generated automatic mounting point when we boot
genfstab -U /mnt >> /etc/fstab

#After we changed the fstab file, we need to reload all deamons
systemctl daemon-reload

#Copy the script that we execute in the chroot
cp arch-chroot.sh /mnt/root/

#Execute the chroot script in the chroot environnement
arch-chroot /mnt /root/arch-chroot.sh