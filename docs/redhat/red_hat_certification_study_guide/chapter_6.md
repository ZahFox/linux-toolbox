# Chapter 6 - Linux Filesystem Administration

## Storage Management and Partitions

In Linux, three tools still predominate for administrators who need to create and manage partitions: `fdisk`, `gdisk`, and `parted`.

### The fdisk Utility

`fdisk` works with partitions created using the traditional Master Boot Record (MBR) partitioning scheme.

Type `m` for help and `q` to quit `fdisk`.
Type `p` to examine the partition table.
Type `d` to delete a partition.
Type `w` to write your changes.

> SATA, PATA, and SAS SCSI drives are all represented by device files such as /dev/sda, /dev/sdb, and so on.

> You can run `partprobe /dev/vdb` to tell the kernel to reload the partition table for a drive.

### The gdisk Utility

The GPT partitioning scheme can hold up to 128 partitions and supports drives of up to 8 million terabytes.

### The parted Utility

At the `parted` command-line prompt, start with the `print` command to list the current partition table. You use `mkpart` to make a new partition or `mkpartfs` to create a new partition and format its filesystem.

#### Using parted: A New PC (or Hard Drive) with No Partitions

1. Label the drive: `mklabel` then type either `msdos` for MBR or `gpt` for GPT.
2. Create a new partition:
   1. MBR: `mkpart` then `primary` then `xfs` then `1MB` then `500MB`.
3. Review the partition: `print`

#### Using parted: Delete a Partition

To delete a partition by number, use the `rm` command from the (**parted**) prompt. Before deleting a partition, you should do the following:

- Save any data you need from that partition.
- Unmount the partition.
- Make sure it isn't configured in `/etc/fstab` so Linux doesn't try to mount it the next time you boot.
- After starting `parted`, run the `print` command to identify the partition you want to delete, as well as its ID number.

## Filesystem Formats

In the following sections we split filesystems into two broad categories: "standard formatting" and journaling.

### Standard Formatting Filesystems

In general, these are considered to be legacy filesystems (because they don't support journaling). However, filesystems such as ISO 9660 and swap are still in common use.

| **Filesystem Type**    | **Description**                                                                                                                                                                                               |
| :--------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ext                    | The first Linux filesystem, used only on early versions of the OS.                                                                                                                                            |
| ext2 (Second Extended) | The foundation for ext3, used by default in RHEL 5.                                                                                                                                                           |
| swap                   | Associated with dedicated swap partitions.                                                                                                                                                                    |
| MS-DOS and VFAT        | Allow you to read MS-DOS-formatted filesystems. MS-DOS for pre-Windows 95, and VFAT for Windows 9x/NT/2000/XP/Vista/7 formatted to the FAT16 or FAT32 filesystem.                                             |
| ISO 9660               | The standard filesystem for CD-ROMs. Its is also known as the High Sierra File System, or HSFS, on other Unix systems.                                                                                        |
| proc and sys           | Two Linux virtual filesystems. Virtual means that the filesystem doesn't occupy real disk space. Instead, files are created as needed. Used to provide information on kernel configuration and device status. |
| devpts                 | The Linux implementation of the Open Group's Unix98 PTY support.                                                                                                                                              |
| tmpfs                  | A filesystem stored in memory. Used on RHEL 7 for the /run partition                                                                                                                                          |

### Journaling Filesystems

Journaling filesystems have two main advantages. First, they're faster for Linux to check during the boot process. Second, if a crash occurs, a journaling filesystem has a log (also known as a journal) that can be used to restore the metadata for the files on the relevant partition.

| **Filesystem Type** | **Description**                                                                                                                                                                |
| :------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ext3                | Default filesystem for RHEL 5                                                                                                                                                  |
| ext4                | Default filesystem for RHEL 6                                                                                                                                                  |
| XFS                 | Support for very large files and features such as B-tree indexing and dynamic allocation inodes.                                                                               |
| JFS                 | IBM's journaled filesystem, commonly used on IBM enterprise servers.                                                                                                           |
| Btrfs               | The B-tree filesystem was developed to offer a set of features comparable with Oracle ZFS. It offers some advanced features such as snapshots, storage pools, and compression. |
| NTFS                | The current Microsoft Windows filesystem.                                                                                                                                      |

### Filesystem Format Commands

Several commands can help you create a Linux filesystem. They're all based on the `mkfs` command, which works as a front end to filesystem-specfic commands such as `mkfs.ext3`, `mkfs.ext4`, and `mkfs.xfs`.

Format a volume to the XFS filesystem:

```bash
mkfs -t xfs <VOLUME_PATH>
# or
mkfs.xfs <VOLUME_PATH>
```

### Swap Volumes

To see the swap space currently configured, run the `cat /proc/swaps` command.

Swap volumes are formatted with the `mkswap` command and activated with the `swapon` command. You also need to make sure to configure the swap volume in the `/etc/fstab` file.

### Filesystem Check Commands

The `fsck` command analyzes the specified filesystem and performs repairs as required.

## Basic Linux Filesystems and Directories

Everything in Linux can be reduced to a file. Partitions are associated with _filesystem device nodes_ such as `/dev/sda1`. Hardware components are associated with node files such as `/dev/cdrom`. Detected devices are documented as file in the `/sys` directory.

The Filesystem Hierarchy Standard (FHS) is the official way to organize files in Unix and Linux directories.

### Separate Linux Filesystems

| **Directory** | **Description**                                                                                                                                                                                                                                                                                                                       |
| :------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| /             | The root directory, the top-level directory in the FHS. All other directories are subdirectories or root, which is always mounted on some volume.                                                                                                                                                                                     |
| /bin          | Essential command-line utilities. Should not be mounted separately; otherwise, it could be difficult to get to these utilities when using a rescue disk. On RHEL 7, it is a symbolic link to `/usr/bin`.                                                                                                                              |
| /boot         | Includes Linux startup files, including the Linux kernel. The default, 500MB is usually sufficient for a typical modular kernel and additional kernels that you might install.                                                                                                                                                        |
| /dev          | Hardware and software device drivers for everything from floppy drives to terminals. Do not mount this directory on a separate volume.                                                                                                                                                                                                |
| /etc          | Most basic configuration files. Do not mount this directory on a separate volume.                                                                                                                                                                                                                                                     |
| /home         | Home directories for almost every user.                                                                                                                                                                                                                                                                                               |
| /lib          | Program libraries for the kernel and various command-line utilities. Do not mount this directory on a separate volume. On RHEL 7, this is a symbolic link to `/usr/lib`.                                                                                                                                                              |
| /lib64        | Same as `/lib`, but includes 64-bit libraries. On RHEL 7, this is a symbolic link to `/usr/lib64`.                                                                                                                                                                                                                                    |
| /media        | The mount point for removeable media, including DVDs and USB disk drives.                                                                                                                                                                                                                                                             |
| /misc         | The standard mount point for local directories mounted via the automounter.                                                                                                                                                                                                                                                           |
| /mnt          | A mount point for temporarily mounted filesystems.                                                                                                                                                                                                                                                                                    |
| /net          | The standard mount point for network directories mounted via the automounter.                                                                                                                                                                                                                                                         |
| /opt          | Common location for third-party application files.                                                                                                                                                                                                                                                                                    |
| /proc         | A virtual filesystem listing information for currently runnign kernel-related processes, including device assignments such as IRQ ports, I/O addresses, and DMA channels, as well as kernel-configuration settings such as IP forwarding. As a virtual filesystem, Linux automatically configures it as a separate filesystem in RAM. |
| /root         | The home directory for the root user. Do not mount this directory on a separate volume.                                                                                                                                                                                                                                               |
| /run          | A tmpfs filesystem for files that should not persist after a reboot. On RHEL 7, this filesystem replaces `/var/run`, which is a symbolic link to `/run`.                                                                                                                                                                              |
| /sbin         | System administration commands. Don't mount this directory separately. On RHEL 7, this is a symbolic link to `/usr/bin`.                                                                                                                                                                                                              |
| /smb          | The standard mount point for remote shared Microsoft network directories mounted via the automounter.                                                                                                                                                                                                                                 |
| /srv          | Commonly used by various network server on non-Red Hat distributions.                                                                                                                                                                                                                                                                 |
| /sys          | Similar to the `/proc` filesystem. Used to expose information about devices, drivers, and some kernel features.                                                                                                                                                                                                                       |
| /tmp          | Temporary files. By default, Red Hat Enterprise Linux deletes all files in this directory periodically.                                                                                                                                                                                                                               |
| /usr          | Programs and read-only data. Includes many system administation commands, utilities, and libraries.                                                                                                                                                                                                                                   |
| /var          | Variable data, including log files and printer spools.                                                                                                                                                                                                                                                                                |

## Logical Volume Management (LVM)

Logical Volume Management (LVM, also known as the Logical Volume Manager) creates an abstraction layer between physical devices, such as disks and partitions, and volumes that are formatted with a filesystem.

### Definitions in LVM

- **Physical volume (PV)** - A PV is a partition or a disk drive initialized to be used by LVM.
- **Physical extent (PE)** - A PE is a small uniform segment of disk space. PVs are split into PEs.
- **Volume group (VG)** - A VG is a storage pool, made of one or more PVs.
- **Logical extent (LE)** - Every PE is associated with an LE, and these PEs can be combined into a logical volume.
- **Logical volume (LV)** - An LV is a part of a VG and is made of LEs. An LV can be formatted with a filesystem and then mounted on the directory of your choice.

### Create a Physical Volume

The first step is to start with a physical parition or a hard disk drive. Create a partition with the Linux LVM identifier. After that, make the partition a PV using the `pvcreate` command. (e.g., `pvcreate /dev/sda1`)

### Create a Volume Group

Add one or more PVs to a new volume group:

`vgcreate <VOLUME_GROUP_NAME> <PV_PARTITIONS...>`
(e.g., `vgcreate volumegroup /dev/sda1 /dev/sda2`)

Add additional PVs to a VG:

`vgextend <VOLUME_GROUP_NAME> <PV_PARTITIONS...>`
(e.g., `vgextend volumegroup /dev/sdb1 /dev/sdb2`)

### Create a Logical Volume

`lvcreate -l <NUMBER_OF_PEs> <VOLUME_GROUP_NAME> -n <LOGICAL_VOLUME_NAME>`
`lvcreate -L <SIZE_IN_BYTES> <VOLUME_GROUP_NAME> -n <LOGICAL_VOLUME_NAME>`
(e.g., `lvcreate -L 200M volumegroup -n flex`)

### More LVM Commands

#### Physical Volume Commands

| **Physical Volume Command** | **Description**                                                                                                                                                                                                                                                                                          |
| :-------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| pvchange                    | Changes attributes of a PV: the `pvchange -x n /dev/sda10` command disables the allocation of PEs from the `dev/sda10` partition.                                                                                                                                                                        |
| pvck                        | Checks the consistency of a physical volume's metadata.                                                                                                                                                                                                                                                  |
| pvcreate                    | Initializes a disk or partition as a PV; the partition should be flagged with the LVM file type.                                                                                                                                                                                                         |
| pvdisplay                   | Displays the currently configured PVs.                                                                                                                                                                                                                                                                   |
| pvmove                      | Moves PEs in a VG from the specified PV to free locations on other PVs; prerequisite to disabling a PV. `pvmove /dev/sda10`                                                                                                                                                                              |
| pvremove                    | Removes a given PV from a list of recognized volumes. `pvremove /dev/sda10`                                                                                                                                                                                                                              |
| pvresize                    | Changes the amount of a partition allocated to a PV. If you've expanded partition `/dev/sda10`, `pvresize /dev/sda10` takes advantage of the additional space. Alternatively, `pvresize --setphysicalvolumesize 100M /dev/sda10` reduces the amount of PVs taken from that partition to the noted space. |
| pvs                         | Lists configured PVs and the associated VGs, if so assigned.                                                                                                                                                                                                                                             |
| pvscan                      | Scans disks for physical volumes.                                                                                                                                                                                                                                                                        |

#### Volume Group Commands

| **Volume Group Command**   | **Description**                                                                                                                                  |
| :------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------- |
| vgcfgbackup & vgcfgrestore | Used to back up and restore the metadata associated with LVM; by default, the ackup files are in the `/etc/lvm` directory.                       |
| vgchange                   | Similar to `pvchange`, this command allows you to change the configuration settings of a VG. For example, `vgchange -a y` enables all local VGs. |
| vgck                       | Checks the consistency of a volume group metadata.                                                                                               |
| vgconvert                  | Supports conversions from LVM1 systems to LVM2: `vgconvert -M2 VolGroup00` converts VolGroup00 to the LVM2 metadata format.                      |
| vgcreate                   | Creates a VG, from one or more configured PVs.                                                                                                   |
| vgdisplay                  | Displays characteristics of currently configured VGs.                                                                                            |
| vgexport & vgimport        | Used to export and import unused VGs from those available; the `vgexport -a` command exports all inactive VGs.                                   |
| vgextend                   | If you've created a new PV, `vgextend vgroup00 /dev/sda11` add the space from `/dev/sda11` to vgroup00.                                          |
| vgmerge                    | If you have an unused VG vgroup01, you can merge it into a vgroup00 with the following command: `vmerge vgroup00 vgroup01`.                      |
| vgmknodes                  | Run this command if you have a problem with VG device files.                                                                                     |
| vgreduce                   | The `vgreduce vgroup00 /dev/sda11` command removes the `/dev/sda11` PV from vgroup00, assuming `/dev/sda11` is unused.                           |
| vgremove                   | The `vgremove vgroup00` commadn removes vgroup00 assuming it has no LVs assigned to it.                                                          |
| vgrename                   | Allows the renaming of LVs.                                                                                                                      |
| vgs                        | Displays basic information on configured VGs.                                                                                                    |
| vgscan                     | Scans all devices for VGs.                                                                                                                       |
| vgsplit                    | Splits a volume group.                                                                                                                           |

#### Logical Volume Commands

| **Logical Volume Command** | **Description**                                                                                                                                                         |
| :------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| lvchange                   | Similar to `pvchange`, this command changes the attributes o an LV: for example, the `lvchange -a n vgroup00/lvol00` command disables the use of the LV labeled lvol00. |
| lvconvert                  | Converts a logical volume between different types, such as linear, mirror, or snapshot.                                                                                 |
| lvcreate                   | Create a new LV in an existing VG.                                                                                                                                      |
| lvdisplay                  | Displays currently configured LVs.                                                                                                                                      |
| lvextend                   | Adds space to an LV: the `lvextend -L 4G /dev/volume01/lvol01` command extends lvol1 to 4GB, assuming space is available.                                               |
| lvreduce                   | Reduces the size off an LV; if there's data in the reduced area, it is lost.                                                                                            |
| lvremove                   | Removes an active LV: the `lvremove volume01/lvol01` command removes an LV lvol01 from VG volume01.                                                                     |
| lvrename                   | Renames an LV.                                                                                                                                                          |
| lvresize                   | Resizes an LV; can be done by `-L` for size. For example, `lvresize -L +4GB volume01/lvol01` adds 4GB to the size of lvol01.                                            |
| lvs                        | Lists all configured LVs.                                                                                                                                               |
| lvscan                     | Scans for all LVs.                                                                                                                                                      |

### Remove a Logical Volume

1. Save any data in directories the are mounted on the LV.
2. Unmount the filesystem associated with the LV. As an example, you can use a command similar to the following: `umount /dev/vg_01/lv_01`.
3. Apply the `lvremove` command to the LV with a command such as this: `lvremove /dev/vg_01/lv_01`.
4. You should now have the LEs from this LV free for use in other LVs.

### Resize Logical Volumes

1. Back up any data existing on the `/home` directory.
2. Extend the VG to include new partitions configured to the appropriate type. For example, to add `/dev/sdd1` to the vg_00 VG, run the following command: `vgextend vg_00 /dev/sdd1`.
3. Make sure the new partitions are included in the VG with the following command: `vgdisplay vg_00`.
4. Now you can extend the space given to the current LV. For example, to extend the LV to 2000MB, run the following command: `lvextend -L 2000M /dev/vg_00/lv_00`.
5. The `lvextend` command can increase the space allocated to an LV in KB, MB, GB, or even TB. If you prefer to specify extra space to be added rather than total space, you can do this: `lvextend -L +1G /dev/vg_00/lv_00`.
6. Resize the formatted volume with the `xfs_growfs` command (or with `resize2fs`, if it is an ext2/ext3/ext4 filesystem). If you're using the entire extended LV, the command is simple: `xfs_growfs /dev/vg_00/lv_00`.
7. Finish the process by checking the new filesystem size with the `df` command: `df -h`.

## Filesystem Management

When Linux goes through the boot process, directories specified in `/etc/fstab` are mounted on configured volumes, with the help of the `mount` command.

### The `/etc/fstab` File

#### Description of `/etc/fstab` by Column, Left to Right

| **Attribute**          | **Description**                                                                                                                                                                                                                                                                                                        |
| :--------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Device                 | Lists the device to be mounted; you may substitute the UUID or the device path.                                                                                                                                                                                                                                        |
| Mount Point            | Notes the directory where the filesystem will be mounted.                                                                                                                                                                                                                                                              |
| Filesystem Format      | Describes the filesystem type. Valid filesystem types are xfs, ext2, ext3, ext4, msdos, vfat, iso9660, nfs, smb, swap, and many others.                                                                                                                                                                                |
| Mount Options          | Covered in the following section.                                                                                                                                                                                                                                                                                      |
| Dump Value             | Either 0 or 1. If you use the `dump` command to back up filesystems, this field controls which filesystems need to be dumped.                                                                                                                                                                                          |
| Filesystem Check Order | Determines the order that filesystems are checked by the `fsck` command during the boot process. The root directory (/) filesystem should be set to 1, and other local filesystems should be set to 2. Removeable filesystems should be set to 0, which means that they are not checked during the Linux boot process. |

### Universally Unique Identifiers in `/etc/fstab`

Use the `blkid` command to get the UUID for a volume: `blkid <VOLUME_PATH>`
(e.g., `blkid /dev/sda1`)

### The `mount` Command

The `mount` command can be used to attach local and network partitions to specified directories.

Run `mount` by itself to list all currently mounted filesystems, along with important mount options.

If you've unmounted a directory and have made changes to the `/etc/fstab` file, the easiest way to mount all filesystems currently configured in the `/etc/fstab` file is with the following command: `mount -a`.

Remount a volume in read-only mode: `mount -o remount,ro <DIRECTORY>`
(e.g., `mount -o remount,ro /boot`)

### More Filesystem Mount Options

| **Attribute** | **Description**                                                                                                         |
| :------------ | :---------------------------------------------------------------------------------------------------------------------- |
| async         | All I/O is done asynchronously on this filesystem.                                                                      |
| atime         | Updates the inode access time ever time the file is accessed.                                                           |
| auto          | Can be mounted with the `mount -a` command.                                                                             |
| defaults      | Uses default mount options `rw`, `suid`, `dev`, `exec`, `auto`, `nouser`, and `async`.                                  |
| dev           | Permits access to character devices such as terminals or consoles and block devices such as drives.                     |
| exec          | Allows binaries to be run on this filesystem.                                                                           |
| noatime       | Does not update the inode access time every time the file is accessed.                                                  |
| noauto        | Requires explicit mounting. This is a common option for CD drives and removable media.                                  |
| nodev         | Device files on this filesystem are not read or interpreted.                                                            |
| noexec        | Binaries cannot be run on this filesystem.                                                                              |
| nosuid        | Disallows `setuid` and `setgid` permissions on this filesystem.                                                         |
| nouser        | Only root users are allowed to mount the specified filesystem.                                                          |
| remount       | Remounts a currently mounted filesystem.                                                                                |
| ro            | Mounts the filesystem as read-only.                                                                                     |
| rw            | Mounts the filesystem as read/write.                                                                                    |
| suid          | Allows `setuid` and `setgid` permissions on programs on this filesystem.                                                |
| sync          | All I/O is done synchronously on this filesystem.                                                                       |
| user          | Allows non-root users to mount this filesystem. By default, this also sets the `noexec`, `nosuid`, and `nodev` options. |

### Networked Filesystems

The two major sharing servies of interest are NFS and Samba.

A connection to a shared NFS directory is based on its hostname or IP address, along with the full path to the directory on the server. So to connect to a remote NFS server on system _server1_ that shares the `/pub` directory, you could mount that share with the following command: `mount -t nfs server1.example.com:/pub /share`. However, this does not specify any mount options. You could also add this entry to `/etc/fstab`: `server1:/pub /share nfs rsize=65536,wsize=65536,hard,udp 0 0`.

Shared Samba directories use a different set of options. The following line is generally all that's needed for a share of the same directory and server: `//server1/pub /share cifs rw,username=user,password=pass, 0 0` or `//server/pub /share cifs rw,credentials=/etc/secret 0 0`.

## The Automounter

The automount daemon, also known as the automounter or `autofs`, can automatically mount a specific filesystem as needed. It can unmount a filesystem automatically after a fixed period of time.

### Mounting via the Automounter

The relevant configuration files are `auto.master`, `auto.misc`, `auto.net`, and `auto.smb`, all in the `etc` directory.

Default automounter settings are configured in `/etc/sysconfig/autofs`.

### Activate the Automounter

As it is governed by the `autofs` daemon, you can stop, start, restart, or reload that service with one of the following commands:

```bash
systemctl stop autofs
systemctl start autofs
systemctl restart autofs
systemctl reload autofs
```

## Scenario & Solution

**Scenario:**

You need to configure several new partitions for a standard Linux partition, for swap space, adn for a logical volume.

**Solution:**

Use the `fdisk`, `gdisk`, or `parted` utility to create partitions, and then modify their partition types with the `t` or `set` command.

**Scenario:**

You want to set up a mount during the boot process based on the UUID.

**Solution:**

Identify the UUID of the volume with the `blkid` command, and use that UUID in the `/etc/fstab` file.

**Scenario:**

You need to format a volume to the XFS filesystem type.

**Solution:**

Format the target volume with the command `mkfs.xfs`.

**Scenario:**

You need to format a volume to the ext2, ext3, or ext4 filesystem type.

**Solution:**

Format the target volume with a command such as `mkfs.ext2`, `mkfs.ext3`, or `mkfs.ext4`.

**Scenario:**

You want to set up a logical volume.

**Solution:**

Use the `pvcreate` command to create PVs; use the `vgcreate` command to combine PVs in VGs; use the `lvcreate` command to create an LV; format that LV for use.

**Scenario:**

You want to add new filesystems without destroying others.

**Solution:**

Use the free space on existing of newly installed hard drives.

**Scenario:**

You want to expand the space available to an LV formatted with the XFS filesystem.

**Solution:**

Use the `lvextend` command to increase the space available to an LV, and then use the `xfs_growfs` command to expand the formatted filesystem accordingly.

**Scenario:**

You need to configure automated mounts to a shared network filesystem.

**Solution:**

Configure the filesystem either in `/etc/fstab` or through to automounter.

## Key Points

### 1. Storage Management and Partitions

- The `fdisk`, `gdisk`, and `parted` utilities can help you create and delete partitions.
- `fdisk`, `gdisk`, and `parted` can be used to configure partitions for logical volumes and RAID arrays.
- Disks can use the traditional MBR-style partitioning scheme, which supports primary, extended, and logical partitions, or the GPT scheme, which supports up to 128 partitions.

### 2. Filesystem Formats

- Linux tools can be used to configure and format volumes to a number of different filesystems.
- Examples of standard filesystems include MS-DOS and ext2.
- Journaling filesystems, which include logs that can restore metadata, are more resilient; the default RHEL 7 filesystem is XFS.
- RHEL 7 supports a variety of `mkfs.*` filesystem format-check and `fsck.*` filesystem check commands.

### 3. Basic Linux Filesystems and Directories

- Linux file and filesystems are organized into directories based on the FHS.
- Some Linux directories are well suited to configuration on separate filesystems.

### 4. Logical Volume Management (LVM)

- LVM is based on physical volumes, logical volumes, and volume groups.
- You can create and add LVM systems with a wide variety of commands, starting with `pv*`, `lv*`, and `vg*`.
- The space from new partitions configured as PVs can be allocated to existing volume groups with the `vgextend` command; they can be added to LVs with the `lvreate` and `lvextend` commands.
- The extra space can be used to extend and existing XFS filesystem with the `xfs_growfs` command.

### 4. Filesystem Management

- Standard filesystems are mounted as defined in `/etc/fstab`.
- Filesystem volumes are usually indetified by their UUIDs; for a list, run the `blkid` command.
- The `mount` command can either use the settings in `/etc/fstab` or mount filesystem volumes directly.
- It's also possible to configure mounts of shared network directories from NFS and Samba servers in `/etc/fstab`.

### 5. The Automounter

- With the automounter, you can configure automatic mounts of removable media and shared network drives.
- Key automounter configuration files are `auto.master`, `auto.misc`, and `auto.net`, in the `/etc` directory.
