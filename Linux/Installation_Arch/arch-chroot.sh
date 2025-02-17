#!/bin/bash

#All executed commands are printed to the terminal
set -e

#Set the time zone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#Set the hardware clock to UTC
hwclock -wu

#Install a CLI text editor and utils
pacman -S linux-headers git base-devel vim --noconfirm

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

#Extend life of SSD
systemctl enable fstrim.timer

#Network Configuration (Need to use it more)
systemctl enable NetworkManager

#Simple Time protocol client (SNTP not NTP)
systemctl enable systemd-timesyncd

#Uncomment multilib (Include = /etc/pacman.d/mirrorlist) in /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

#Uncomment in visudo the %wheel + Defaults rootpw + Defaults insults
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
sed -i "s/# Defaults targetpw /Defaults rootpw/" /etc/sudoers
echo "Defaults insults" >> /etc/sudoers

#Copy the repo somewhere (all this files)
mkdir /home/firegol513/Repo
git clone https://github.com/FireGol513/ArchConfig.git /home/firegol513/Repo

#Initial ramdisk ?
mkinitcpio -P
