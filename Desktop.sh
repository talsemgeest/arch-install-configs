export EDITOR=nano

echo "en_NZ.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_NZ.UTF-8 > /etc/locale.conf
export LANG=en_NZ.UTF-8

ln -s /usr/share/zoneinfo/NZ /etc/localtime
hwclock --systohc --localtime

echo WINTERFELL > /etc/hostname
systemctl enable dhcpcd.service

mkinitcpio -p linux

pacman -S grub
chmod -x /etc/grub.d/10_linux
echo "Enter disk letter to install Grub to (e.g. \"a\" for /dev/sda"
read disk
grub-install --target=i386-pc --recheck /dev/sd$disk
grub-mkconfig -o /boot/grub/grub.cfg

echo "Set password for root:"
passwd

useradd -m -g users -G wheel,games -s /bin/bash talsemgeest
echo "Set password for talsemgeest:"
passwd talsemgeest

visudo

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Syy

pacman -S smbclient xorg-server xorg-server-utils nvidia lib32-nvidia-libgl ttf-dejavu wget

su talsemgeest <<'EOF'
mkdir /home/talsemgeest/packages
cd /home/talsemgeest/packages
wget https://aur.archlinux.org/packages/pa/packer/packer.tar.gz
tar zxvf packer.tar.gz
cd packer
makepkg -s
EOF
pacman -U /home/talsemgeest/packages/packer/packer-*-any.pkg.tar.xz

echo "[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
export EDITOR=nano
complete -cf sudo
alias ls='ls --color=auto'
alias untgz='tar -zxvf'
alias pacman='packer'
alias pacmanu='sudo pacman -U'
alias pacmanr='sudo pacman -R'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias mount='mount |column -t'
alias ping='ping -c 5'
alias rm='rm --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias snano='sudo nano'
alias psyu='packer -Syu'
alias startup='gnome-session-properties'" > /home/talsemgeest/.bashrc


