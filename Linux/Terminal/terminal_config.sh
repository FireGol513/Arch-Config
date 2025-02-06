#!/bin/bash


#Install yay 
cd /opt
git clone https://aur.archlinux.org/yay-bin.git
chmod 777 -R /opt/yay-bin
cd yay-bin
makepkg -si

#Install zsh + highlighting + Terminal
yes | yay -S zsh zsh-syntax-highlighting kitty
chsh -s $(which zsh) #Need host interaction

#Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Syntax-highlighting
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

#Kitty
#Config file ~/.config/kitty/kitty.conf
cp kitty.conf ~/.config/kitty/

#kitten ssh user@server [Arguement of ssh command] (Solution for the xterm-kitty problem of remote host)


#Install the script for OhMyPosh for installation and run it
curl -s https://ohmyposh.dev/install.sh | bash -s

#Install the nerd fonts (need to run in sudo)
sudo oh-my-posh font install meslo

#Add new line in ~/.zshrc
mkdir ~/.config/OhMyPosh
cp config.json ~/.config/OhMyPosh
echo 'eval "$(oh-my-posh init zsh --config ~/.config/OhMyPosh/config.json)"' >> ~/.zshrc

#I use the theme sonicboom_dark (https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/sonicboom_dark.omp.json)
#Other good one: blue-owl, json, lambdageneration, multiverse-neon, sonicboom_dark



