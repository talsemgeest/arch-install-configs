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
grub-mkconfig -o /boot/grub/grub.cfg

echo "Set root passwd:"
passwd

useradd -m -g users -G wheel,games -s /bin/bash talsemgeest
echo "Set password for talsemgeest"
passwd talsemgeest

visudo

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

echo "Enter disk letter to install Grub to (e.g. \"a\" for /dev/sda"
read =n 1 disk
grub-install --target=i386-pc --recheck /dev/sd"$disk"
