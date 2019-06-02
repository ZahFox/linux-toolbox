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

- **Physical volume (PV)** - A PV is a partition or a disk drive initialized to be useb by LVM.
- **Physical extent (PE)** - A PE is a small uniform segment of disk space. PVs are split into PEs.
- **Volume group (VG)** - A VG is a storage pool, made of one or more PVs.
- **Logical extent (LE)** - Every PE is associated with an LE, and these PEs can be combined into a logical volume.
- **Logical volume (LV)** - An LV is a part of a VG and is made of LEs. An LV can be formated with a filesystem and then mounted on the directory of your choice.

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
2. Unmount the fielsystem associated with the LV. As an example, you can use a command similar to the following: `umount /dev/vg_01/lv_01`.
3. Apply the `lvremove` command to the LV with a command such as this: `lvremove /dev/vg_01/lv_01`.
4. You should now have the LEs from this LV free for use in other LVs.

### Resize Logical Volumes

1. Back up any data existing on the `/home` directory.
2. Extends the VG to include new partitions configured to the appropriate type. For example, to add `/dev/sdd1` to the vg_00 VG, run the following command: `vgextend vg_00 /dev/sdd1`.
3. Make sure the new partitions are included in the VG with the following command: `vgdisplay vg_00`.
4. Now you can extend the space given to the current LV. For example, to extend the LV to 2000MB, run the following command: `lvextend -L 2000M /dev/vg_00/lv_00`.
5. The `lvextend` command can increase the space allocated to an LV in KB, MB, GB, or even TB. If you prefer to specify extra space to be added rather than total space, you can do this: `lvextend -L +1G /dev/vg_00/lv_00`.
6. Resize the formatted volume with the `xfs_growfs` command (or with `resize2fs`, if it is an ext2/ext3/ext4 filesystem). If you're using the entire extended LV, the command is simple: `xfs_growfs /dev/vg_00/lv_00`.
7. Finish the process by checking the new filesystem size with the `df` command: `df -h`.

## Filesystem Management

## The Automounter
