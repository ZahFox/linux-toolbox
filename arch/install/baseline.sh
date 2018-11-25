# Initial Configuration
newuser="zahfox"
fware="BIOS"
ptable="GPT"
disk=/dev/sda

pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO96Mkloi3oGjxBrsoiNCs+eDmA/zG3Er3z9MX0JftEOpE5fkkz1yOV7TFHbl3WQRQb7vl2rH2tJ3ViEV/YWtVo0XNhcPygdYdNMPamKh0TQvm4WZretbVVRiXJAFT17phDmsS28xDZ+BJqebJLMALqKMnKs8gZnCHhEaFRiRUsUOJPB6yI0MyqVBftUXv/h0Vi9kuZUpZ4GWtTJYtjoDeozlQF2S91vA3Db+Hc4uq3DsFMdcMDv5FTkDAt8xWqaTQ9WLn7Q8Vnkz3XllHPp0G96/60lRGd6hI/BHTIqhDBHYFZtkZFhZW84bmql6YsLA8OxAqzXXV0FPt2vaKt+mB William@ULTRA-REX"
hostname="oculi"$[ 1 + $[ RANDOM % 10 ]]""
pingcheckhost="www.gooogle.com"
timezone=America/Chicago
lang="en_US.UTF-8"
locale="$lang UTF-8"
packages="base \
  base-devel \
  dialog \
  fzf \
  git \
  grub \
  htop \
  net-tools \
  openssh \
  sudo \
  tmux \
  tree \
  vim \
  zsh"

# Wait for host to be reachable (including dns query)
while ! ping -c1 -W0.3 "$pingcheckhost" > /dev/null; do
  sleep 0.2
done

reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

# Partition, Format, and Mount Hard Disk
sgdisk -Z $disk
if [ "$fware" = "BIOS" ]; then
  sgdisk -n 0:0:+200M -t 0:ef02 -c 0:"bios" $disk
  sgdisk -n 0:0:+1G -t 0:8300 -c 0:"boot" $disk
  sgdisk -n 0:0:+1G -t 0:8200 -c 0:"swap" $disk
  sgdisk -n 0:0:0 -t 0:8300 -c 0:"root" $disk
  mkfs.fat -F 32 -n bios_grub ${disk}1
else
  sgdisk -n 0:0:+550M -t 0:ef00 -c 0:"efi" $disk
  sgdisk -n 0:0:+1G -t 0:8300 -c 0:"boot" $disk
  sgdisk -n 0:0:+1G -t 0:8200 -c 0:"swap" $disk
  sgdisk -n 0:0:0 -t 0:8300 -c 0:"root" $disk
  mkfs.fat -F 32 -n EFI ${disk}1
fi

mkfs.ext4 -F ${disk}2
mkfs.ext4 -F ${disk}4
mkswap ${disk}3
swapon ${disk}3
mount ${disk}4 /mnt
mkdir /mnt/boot
mount ${disk}2 /mnt/boot

# Install New Packages
pacstrap /mnt $(echo $packages)

# Prepare New Host
genfstab -U /mnt >> /mnt/etc/fstab
echo $hostname >> /mnt/etc/hostname
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
arch-chroot /mnt hwclock --systohc
echo $locale > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=$lang" > /mnt/etc/locale.conf
echo "127.0.0.1     localhost" >> /mnt/etc/hosts
echo "::1           localhost" >> /mnt/etc/hosts
echo "127.0.1.1     ${hostname}.localdomain ${hostname}" >> /mnt/etc/hosts
arch-chroot /mnt systemctl enable dhcpcd
arch-chroot /mnt systemctl start dhcpcd
arch-chroot /mnt mkinitcpio -p linux

# Install Boot Loader (GRUB)
if [ "$fware" = "BIOS" ]; then
  grub-install --target=i386-pc --recheck $disk --root-directory=/mnt
else
  mkdir /mnt/boot/loader
  mount ${disk}1 /mnt/boot/loader
  grub-install --target=x86_64-efi --efi-directory=/mnt/boot/loader --bootloader-id=GRUB --root-directory=/mnt
  printf "FS0:\n\\\EFI\\GRUB\\grubx64.efi\n" > /mnt/boot/loader/startup.nsh
fi

sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /mnt/etc/default/grub
echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> /mnt/etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# Configure Default User
arch-chroot /mnt echo '%wheel      ALL=(ALL) ALL' | sudo EDITOR='tee -a' visudo
noauthsudo="Defaults:$newuser      "'!authenticate'
arch-chroot /mnt echo $noauthsudo | sudo EDITOR='tee -a' visudo
arch-chroot /mnt useradd -m -g users -G wheel $newuser

# Configure SSH
mkdir /mnt/root/.ssh
touch /mnt/root/.ssh/authorized_keys
chmod 700 /mnt/root/.ssh
chmod 600 /mnt/root/.ssh/authorized_keys
cat <<EOF > /mnt/root/.ssh/authorized_keys
$pub
EOF

mkdir /mnt/home/$newuser/.ssh
chmod 700 /mnt/home/$newuser/.ssh
cp /mnt/root/.ssh/authorized_keys /mnt/home/$newuser/.ssh/authorized_keys
chmod 600 /mnt/home/$newuser/.ssh/authorized_keys
arch-chroot /mnt chown -R $newuser:users /home/$newuser/.ssh
arch-chroot /mnt passwd -d $newuser
arch-chroot /mnt systemctl enable multi-user.target sshd

sync