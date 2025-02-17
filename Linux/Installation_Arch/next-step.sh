#Run after arch-chroot
#Run script for terminal

#Run script for installing apps
pacman -S sddm hyprland waybar #Probably in a other script
pacman -S pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber #Probably in a other script
systemctl enable sddm
yay -Syu librewolf-bin rofi-lbonn-wayland

#Run script for configurationj of Hyprland
#Change keybinds in ~/.config/hypr/hyprland.conf

#NVIDIA driver OR AMD driver OR Intel driver OR None
#

#
pacman -S  intel-ucode nvidia nvidia-settings opencl-nvidia nvidia-utils vulkan-icd-loader #Probably in a other script




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



#Virtualisation 
#Death part ;D
LC_ALL=C lscpu | grep Virtualization
zgrep CONFIG_KVM= /proc/config.gz #Only works if y or m
lsmod | grep kvm #Check if kvm and kvm_intel are there
pacman -S qemu-full libvirt virt-manager dnsmasq iptables-nft openbsd-netcat
usermod -aG libvirt firegol513
systemctl enable libvirtd virtlogd