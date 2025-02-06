#This script has the goal to Dual-Boot Windows and Arch-Linux on my GamingPC 
#This is the steps to achieve this

#Can be helpful https://wiki.archlinux.org/title/General_recommendations

#Install Windows on a partition before install Arch
timedatectl set-timezone America/New_York
pacman -Syy archlinux-keyring 
pacstrap -K /mnt base linux linux-firmware networkmanager grub efibootmgr
genfstab -U /mnt >> /etc/fstab
arch-chroot /mnt # Gonna be a problem !!!
mkinitcpio -P
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock -s -u
pacman -Syu vim
#Uncomment en_US.UTF-8 UTF-8 and ca_FR.UTF-8 UTF-8 in /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
useradd -m -g users -G wheel,power,storage firegol513 -s /bin/bash
passwd firegol513
passwd
echo arch-firepc > /etc/hostname
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
systemctl enable fstrim.timer
systemctl enable NetworkManager
systemctl enable systemd-timesyncd

#Uncomment multilib (Include = /etc/pacman.d/mirrorlist) in /etc/pacman.conf
pacman -S linux-headers git base-devel intel-ucode nvidia nvidia-settings opencl-nvidia nvidia-utils vulkan-icd-loader #Probably in a other script
#Uncomment in visudo the %wheel + Defaults rootpw + Defaults insults

#NVIDIA?

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