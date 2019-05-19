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

The loading of Linux depends on a temporary filesystem, known as the initial RAM disk. Once the boot process is complete, control is given to systemd, known as the first process.

### Kernels and the Initial RAM Disk

The initial RAM disk is located in the `/boot` directory and named `initramfs`.

> To learn more about the systemd boot process, disable the **quiet** directive for the desired kernel in the GRUB configuration file. Affter logging in, the boot messages can be reviewed at the `/var/log/dmesg` ffile or by running the `dmesg` command.

### The First Process, Targets, and Units

The first process is **systemd**. In RHEL 7, the legacy **init** process is configured with a symbolic link to **systemd**.

Units are the basic building blocks of systemd. The most common at _service units_, which have a .service extension and activate a system service. To show a list of all service units, type the following command: `systemctl list-unit --type=service --all`

A specical type of unit is a _target unit_, which is used to group together other system units and to transition the system into a different state. The list all target units, type the following command: `systemctl list-units --type=target --all`

| **Target Unit**   | **Description**                                                      |
| :---------------- | :------------------------------------------------------------------- |
| emergency.target  | Emergency shell; only the / filesystem is mounted in read-only mode. |
| graphical.target  | The default target for multiuser graphical systems.                  |
| multi-user.target | Nongraphical multiuser system.                                       |
| rescue.target     | Emergency shell; all filesystems are mounted.                        |

To list the dependencies of a target run: `systemctl list-dependencies <NAME>.target`
To change the default target: `systemctl set-default <NAME>.target`

### Switch Between Targets

First, establish the default target: `systemctl get-default`.

After logging in as the administrative user, you can move to a different target with the `systemctl isolate` command: `systemctl isolate multi-user.target`

### Reboot and Shut Down a System Normally

The commands required to reboot and shut down a system are straightforward. The following commands provider on way to shut down and reboot a system, respectively: `systemctl poweroff` and `systemctl reboot`.

> To display the time required to boot your system, run the following command: `systemd-analyze times`. `systemd-analyze blame` will show the amount of time reuired to activate each systemd unit.

### Logging

The systemd process includes a powerful logging system. You can display all collected logs with the **journalctl** command.

### cgroups

The command **systemd-cgls** displays the cgroup hierarchy in a tree format. This is the dependencies between running processes and their associated services.

### systemd Units

The first process is systemd. The systemd process uses various configuation files to start other processes. You can find these configuration files in the following directories: `/etc/systemd/system` and `/usr/lib/systemd/system`.

| **Unit Type** | **Description**                                                                                                       |
| :------------ | :-------------------------------------------------------------------------------------------------------------------- |
| Traget        | A group of units used as a synchronization point at startup.                                                          |
| Service       | A service, such as a daemon like the Apache web server.                                                               |
| Socket        | An IPC or network socket, used to activate a service when traffic is received on a listening socket.                  |
| Device        | A device such as a drive or partition.                                                                                |
| Mount         | A filesystem mount point controlled by systemd.                                                                       |
| Automount     | A filesystem automount point controlled by systemd.                                                                   |
| Swap          | A swap partition to be activated by systemd.                                                                          |
| Path          | A path monitored by systemd, used to activate a service when a path changes.                                          |
| Timer         | A timer controlled by systemd, used to activate a service when the timer elapses.                                     |
| Snapshot      | Used to create a snapshot of the systemd run-time state.                                                              |
| Slice         | A group of system resources (such as CPU, memory, and so on) that can be assigned to a unit via the cgroup interface. |
| Scope         | A unit for organizing and managing resource utilization of a set of system processes.                                 |

## Control by Target

### Service Configuration

List service unit files: `systemctl list-unit-files --type=service`.

## Time Synchronization

The configuration of a Network Time Protocol (NTP) client is straightforward. Therefore, this section provides an overview of the configuration files and the associated command tools.

RHEL 7 includes RMPs for two NTP daemons: `ntpd` and `chronyd`. Typically, `ntdp` is recommended for systems that are always connected to the network, such as servers, whereas `chronyd` is the preferred choice for virtual and mobile systems.

### Time Zone Configuration

You can display a list of the available time zones by running the following command: `timedatectl list-timezones`. Then, to switch to a different time zone, run `timedatectl` with the `set-timezone` command. `timedatectl set-timezone <TIMEZONE>`.

Example: `timedatectl set-timezone America/Los_Angeles`.

### Sync the Time with chronyd

The default `chronyd` configuration file is located at `/etc/chrony.conf`. To configure `chronyd` to synchronize with a different NTP server, just modify the **server** directives in `/etc/chrony.conf` and restart `chronyd`: `systemctl restart chronyd`.

### Sync the Time with ntpd

First, ensure that `chronyd` is stopped and disabled at boot because you cannot have both `chronyd` and `ntpd` running on the same machine:

```bash
systemctl stop chronyd.service
systemctl disable chronyd.service
```

Next, install the ntp RPM package: `yum install ntp`. The default configuration file is `/etc/ntp.conf`. Once you have cusomtized this file, start and enable `ntpd`:

```bash
systemctl start ntpd.service
systemctl enable ntpd.service
```

## Certification Summary

> Continue here next time
