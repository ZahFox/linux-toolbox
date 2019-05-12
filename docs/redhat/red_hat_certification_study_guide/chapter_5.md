# Chapter 4 - The Boot Process

## Bootloaders and GRUB 2

### GRUB, the GRand Unified Bootloader

#### Boot into Different Targets

To pass a parameter to the kernel through GRUB 2, press E at the first GRUB menu. This allows you to edit the boot parameters sent to the kernel. Locate the line that starts with the directive `linux16`.

The boot target can be changed by appending a `systemd.unit=<NAME>.target` string to the end of the kernel command line.

If you need direct access into a recovery shell, add the string `systemd.unit=rescue.target` to the end of the kernel command line. In rare cases, some systems are so troubled, they don't boot into the rescue target. In that case, two other options are available:

- **systemd.unit=emergency.target** - No filesystem is mounted, apart from the root filesystem in read-only mode.
- **init=/sysroot/bin/sh** - Starts a shell and mounts the root filesystem in read-only mode; does not require a password.

You may also append `rd.break` to login in as root without a password.

Check the current target: `ls -l /etc/systemd/system/default.target` or `systemctl get-default`.

#### Recovering a Lost Root Password

1. reboot the system and press `E` when the GRUB boot menu appears.
2. Append `rd.break` to the linux boot parameters and press `CTRL-x` to boot the system.
3. Remount the root `/sysroot` filesystem as read-write and change the root directory to `/sysroot`:

```bash
mount -o remount,rw /sysroot
chroot /sysroot
```

4. Change the password: `passwd`
5. Ensure that the `/etc/passwd` file is labeled with the correct SELinux context by instructing Linux to relabel all files at the next boot: `touch /.autorelabel`.

### Modify the System Bootloader

The config file for grub is available at `/etc/grub2.cfg`, which is a symbolic link that points to `/boot/grub2/grub.cfg` on systems configured in BIOS mode, or `/boot/efi/EFI/redhat/grub.cfg` for servers that use an UEFI boot manager.

You should not directly edit the `grub.cfg` file. Instead, you can edit the `/etc/default/grub` file and scripts in the `/etc/grub.d/` directory. Once you have modified these files, generate a new GRUB configuration file by running: `grub2-mkconfig -o /boot/grub2/grub.cfg` or `grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg`

Run `grub2-set-default <NUMBER>` to choose a default kernel to boot in to.

Run `grub2-install` to install GRUB over a different bootloader such as Microsoft's NTLDR or BOOTMGR.

### The GRUB 2 Command Line

- During system boot, press `c` to enter the GRUB command line interface.
- Load the LVM module by typing the following command: `insmod lvm`.
- List all partitions and logical volumes: `ls`.
- View the contents of fstab: `cat (lvm/centos-root)/etc/fstab`.
- Set the root variable to the device containing the root filesystem: `set root=(lvm/centos-root)`

### Reinstall GRUB 2

First, list and remove all GRUB @ configuration and script files. The can be done using the following commands:

```bash
rpm -qc grub2-tools
rm -f /etc/default/grub
rm -f /etc/grub.d/*
yum reinstall grub2-tools
grub2-mkconfig -o /boot/grub2/grub.cfg
```

## Between GRUB 2 and Login

> Continue here next time

## Control by Target

## Time Synchronization
