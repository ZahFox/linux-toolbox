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

> If you run `partprobe /dev/vdb`, the kernel will read the new partition table and you'd be able ot use the newly created partition.

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
- After starting `parted`, run the `print` commadn to identify the partition you want to delete, as well as its ID number.

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
| proc and sys           | Two Linux virtual filesystems. Virtual means that the filesystem doesn't occupy real disk space. Instead, fiels are created as needed. Used to provide information on kernel configuration and device status. |
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

## Logical Volume Management (LVM)

## Filesystem Management

## The Automounter
