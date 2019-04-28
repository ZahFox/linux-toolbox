# Chapter 4 - RHCSA-Level Security Options

## Basic File Permissions

### Special Permission Bits

| Special Permission | To File                                | To Directory                              |
| :----------------- | :------------------------------------- | :---------------------------------------- |
| SUID               | Determines user ID when file executes  | No effect.                                |
| GUID               | Determins groupd ID when file executes | All files created in dir get the group ID |
| Sticky Bit         | No effect.                             | Files can only be manipulated by owner.   |

SUID = 4
SGID = 2
sticky bit = 1

### Commands to Change Permissions and Ownership

#### `chmod`

Give the owner user of a file execute access: `# chmod u+x <FILE_PATH>`
Give the owner group of a file only read and write access: `# chmod g=rw <FILE_PATH>`
Give all users execute access to a file: `# chmod +x <FILE_PATH>`
Setting access with SUID set for a file: `# chmod 4764 <FILE_PATH>`
Add the sticky bit to a directory for the owner group: `# chmod g+s <DIRECTORY_PATH>`

#### `chown`

Change the user owner of a file: `# chown <USER> <FILE_PATH>`
Change the user and group owners of a file: `# chown <USER>.<GROUP> <FILE_PATH>`

#### `chgrp`

Change the group owner of a file: `# chgrp <GROUP> <FILE_PATH>`

#### `chattr` and `lsattr`

Prevent any user (including root) from deleting a file: `# chattr +i <FILE_PATH>`
Show the attributes of a file: `# lsattr <FILE_PATH>`

### File Attributes

|   **Attribute**   |               **Description**                |
| :---------------: | :------------------------------------------: |
|  append only (a)  |             Can't delete content             |
|    no dump (d)    |        Dump may not backup this file         |
| extent format (e) |          Set by the ext4 filesystem          |
|   immutable (i)   | Prevent deletion or any other kind of change |

### `umask`

A user can see their umask by issuing the following command: `# umask`

When they create a new file, the umask value is subtracted from 666 (directories are subtracted from 777) to determine the default file permissions. For example, if the umask is `0022`, a new file will be set to `644` or `rw-r--r--`.

The umask for user accounts with UIDs of 200 and above is `0002`, but users below it is `0022`.

## Access Control Lists and More

When you create an XFS or an ext2/ext3/ext4 filesystem on RHEL 7, ACLs are enabled by default.

Remount a fielsystem with ACL enabled: `# mount -o remount -o acl <FILESYSTEM_ROOT_PATH>`

### The `getfacl` and `setfacl` Commands

List the ACL for a file: `# getfacl <FILE_PATH>`
Give a specific user `rwx` access to a file: `# setfacl -m u:<USER>:rwx <FILE_PATH>`
Give a specific group `rwx` access to a file: `# setfacl -m g:<GROUP>:rwx <FILE_PATH>`
Remove a specific user's `rwx` access to a file: `# setfacl -x u:<USER> <FILE_PATH>`
Remove a specific user's `rwx` access to a file: `# setfacl -m u:<USER>:- <FILE_PATH>`
Remove all ACL settings on a file: `# setfacl -b <FILE_PATH>`

> Use -R to apply the command recursively

#### The default ACL

Files in a directory can inherit an ACL from the the default ACL

Set default ACL permissions for a user: `# setfacl -d -m u:<USER>:rx <DIRECTORY_PATH>`

#### ACL Mask

The ACL mask controls which permission may be granted by an ACL

Only allow read permissions to be set in the ACL: `# setfacl -m mask:r-- <DIRECTORY_PATH>`

## Basic Firewall Control

The `iptables` tool is the basic foundation that is used by other services to manage system firewall rules. RHEL 7 comes with two such services: the new firewalld daemon and the iptables service. You can interact with firewalld using the graphical utility `firewall-config` or the command-line client `firewall-cmd`.

> The `iptables` and `firewalld` services both rely on the Netfilter system within the Linux kernel to filter packets.

### iptables

The philosophy behind **iptables** is based on "chains." These are sets of rules applied to each network packet, chained together. Each rules does two things: its specifies the conditions a packet must meet to match the rule, and it specifies the action if the packet matches.

The **iptables** command uses the following basic format:
`# iptables -t <TABLE_TYPE> <ACTION_DIRECTION> <PACKET_PATTERN> -j <WHAT_TO_DO>`

There are two options for `-t <TABLE_TYPE>`:

* **filter** - Sets a rule for filtering packets.
* **nat** - Configures network address translation, also known as masquerading, which is discussed later in Chapter 10.

The following are the options for `<ACTION_DIRECTION>`:

* **-A (--append)** Appends a rule to the end of a chain.
* **-D (--delete)** Deletes a rule from a chain. Specify the rule by the number or packet pattern.
* **-L (--list)** Lists the currently configured rules in the chain.
* **-F (--flush)** Flushes all the rules in the current iptables chain.

For `-A` or `-D` you'll want to apply it to network data traveling in one of three directions:

* **INPUT** - All incoming packets are checked against the rules in this chain.
* **OUTPUT** - All outgoing packets are checked against the rules in this chain.
* **FORWARD** - All packets received from a computer and being sent to another computer are checkd against the rules in this chain. In other words, these are packets that are *routed* through the local server.

`<PACKET_PATTERN>` is the next option. All **iptables** firewalls check every packet against this pattern. The simplest pattern is by IP address:

* **-s *ip_address*** - All packets are checked for a specific source IP address.
* **-d *ip_address*** - All packetes are checked for a specific destination IP address.

Once the **iptables** command finds a packet pattern match, it needs to know what to do with that packet, which leads to the last part of the command, **-j *<WHAT_TO_DO>***. There are three basic options:

* **DROP** - The packet is dropped. No message is sent to the requesting computer.
* **REJECT** - The packet is dropped. An error message is sent to the requesting computer.
* **ACCEPT** - The packet is allowed to proceed as specified with the **-A** action: **INPUT**, **OUTPUT**, or **FORWARD**.

List all of the currently configured **iptables** chain rules: `# iptables -L`

### The iptables Service

Wheras the iptables service was the default firewall running in RHEL 6, firewalld is the default in RHEL 7. If you wish, you can disable firewalld in RHEL 7, and switch to the old iptables service. To do so, run the following commands:

```bash
systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl enable iptables
```

Accept all incoming RELATED and ESTABLISHED connections: `-A INPUT -m state --state REALTED, ESTABLISHED -j ACCEPT`
Accept all incoming ICMP traffic: `-A INPUT -p icmp -j ACCEPT`
Accept all incoming traffic from the loopback interface: `-A INPUT -i lo -j ACCEPT`
Accept all incoming NEW SSH connections over TCP: `-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT`
Reject all other incoming packets:

```
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
```

The COMMIT ends the list of rules: `COMMIT`.

### The firewalld Service

The **firewalld** service offers the same functionalities of the iptable tool and more. One off the new features of firewalld is *zone-based* firewalling. In a zone-based firewall, networks and interffaces are grouped into zones, with each zone configured with a different level of trust.

| **Zone** | **Outgoing Connections**                      | **Incoming Connections**                                              |
| :------- | :-------------------------------------------- | :-------------------------------------------------------------------- |
| drop     | Allowed                                       | Drop                                                                  |
| block    | Allowed                                       | Rejected with an icmp-host prohibited message.                        |
| public   | Allowed                                       | DHCPv6 client and SSH are allowed.                                    |
| external | Allowed and is masqueraded to outgoing NIC IP | SSH is allowed.                                                       |
| dmz      | Allowed                                       | SSH is allowed.                                                       |
| work     | Allowed                                       | DHCPv6 client, IPP and SSH are allowed.                               |
| home     | Allowed                                       | DHCPv6 client, multicast DNS, IPP, Samba client, and SSH are allowed. |
| internal | Allowed                                       | Same as the home zone.                                                |
| trusted  | Allowed                                       | Allowed.                                                              |

#### The GUI `firewall-config` Tool

You can start the graphical firewalld configuration tool from a GUI-based command line with the **firewall-config** command. Alternatively, in the GNOME Desktop Environment, click `Applications | Sundry | Firewall`.

In the main **firewall-config** windows, the public zone is displayed in a bold font to indicate that this zone is the *default zone*. The default zone has a special meaning: any new network interface added to the system is automatically assigned to the default zone. In addition, the rules of the default zone are processed for all incoming packets that do not match any of the other zones.

#### The Console `firewall-cmd` Configuration Tool

The **firewall-cmd** configuration tool has the same features and services as the corresponding GUI tool.

Display the default zone: `firewall-cmd --get-default-zone`
Change the default zone: `firewall-cmd --set-default-zone=internal`
List all the configured interfaces and services in a zone: `firewall-cmd --list-all`
Add HTTP to the dmz zone: `firewall-cmd --zone=domz --add-service=http`
Remove HTTP from the dmz zone: `firewall-cmd --zone=dmz --remove-service=http`
Reload the firewall: `firewall-cmd --reload`

    If you want firewall changes to survive after a reboot use the --permanent switch.

## Securing SSH with Key-Based Authentication

### SSH Configuration Commands

There are a few SSH-oriented utilities you need to know about:

* **sshd** - The daemon service; this must be running to receive inbound Secure Shell client requests.
* **ssh-agent** - A program to hold private keys used for Digital Signature Algorithm (DSA), Elliptic Curve DSA (ECDSA), and Rivest Shamir, Adleman (RSA) authentication. The idea is that the **ssh-agent** command is started in the beginning of an X session or a login session, and other programs are started as clients to the **ssh-agent** program.
* **ssh-add** - Adds private key identities to the authentication agent **ssh-agent**.
* **ssh** - The Secure Shell command, **ssh**, is a secure way to log in to a remote machine, similar to Telnet or **rlogin**.
* **ssh-keygen** - A utility that creates private/public key pairs for SSH authentication. The **ssh-keygen -t keytype** command will create a key pair based on the DSA, ECDSA, or RSA protocol.
* **ssh-copy-id** - A script that copies a public key to a target remote system.

### SSH Client Configuration Files

Systems configured with SSH include configuration files in two different directories. For the local system, basic SSH configuration files are stored in the `/etc/ssh` directory. For each user they are stored in the `~/.ssh/` subdirectory.

* **authorized_keys** - Includes a list of public keys from remote users. Users with public encryption keys in this file can connect to remote systems. The system users and names are listed at the end of each public key copied to this file.
* **id_dsa** - Includes the local private key based on the DSA algorithm.
* **id_dsa.pub** - Includes the local public key for the user based on the DSA algorithm.
* **id_ecdsa** - Includes the local private key based on the ECDSA algorithm.
* **id_ecdsa.pub** - Includes the local public key for the user based on the ECDSA algorithm.
* **id_rsa** - Includes the local private key based on the RSA algorithm.
* **id_rsa.pub** - Includes the local public key for the user based on the RSA algorithm.
* **known_hosts** - Contains the public host keys from remote systems.

### Set Up a Private/Public Pair for Key-Based Authentication

Generate a 8192 bit RSA key pair: `ssh-keygen -b 8192`
Generate a DSA key pair: `ssh-keygen -t dsa`
Transmit public key to remote system: `ssh-copy-id -i <LOCAL_PUBLIC_KEY_PATH> <REMOTE_USER>@<REMOTE_HOST>`

## A Security-Enhanced Linux Primer

Security-Enhanced Linux (SELinux) was developed by the U.S. National Security Agency to provide a level of mandatory access control (MAC) for Linux. It goes beyond the discretionary access control (DAC) associated with file permissions and ACLs.

The SELinux security model is based on subjects, objects, and actions. A *subject* is a process, such as a running command or an application such as the Apache web server in operation. An *object* is a file, a device, a socket, or in general any resource that can be accessed by a subject. An *action* is what may be done by the subject to the object.

SELinux assigns different contexts to objects. A *context* is just a label, which is used by the SELinux security policy to determine whether a subject's action on an object is allowed or not.

### SELinux Status

You need to know how to "set enforcing and permissive modes for SELinux." There are three available modes for SELinux: **enforcing**, **permissive**, and **disabled**. The **enforcing** and **disabled** modes are self-explanatory. SELinux in **permissive** mode means that any SELinux rules that are violated are logged, but the violation does not stop any action.

If you want to change the default SELinux mode, change the `SELINUX` directive in `/etc/selinux/config` file.

| **Directive** |                                                                                                 **Description**                                                                                                  |
| :------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| SELINUX       |                                                               Basic SELinux status; may be set to **enforcing**, **permissive**, or **disabled**.                                                                |
| SELINUXTYPE   | Specifies the level of protection; set to **targeted** by default, where protection is limited to selected "targeted" services. The alternative is **mls**, which is associated with multi level security (MLS). |

### SELinux Configuration at the Command Line

#### Configure Basic SELinux Settings

To see the current status of SELinux, run the **getenforce** coomand; its returns on of three self-explanatory options: **enforcing**, **permissive**, or **disabled**. You may also use **sestatus**.

Change the SELinux status to enforcing: `setenforce enforcing`
Change the SELinux status to permissive: `setenforce permissive`

#### Configure Regular Users for SELinux

To review the status of current SELinux users, run the `semanage login -l` command.

Default status: `unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023`

This status is called a *label* in SELinux jargon. A label is made up of several context strings, separated by a column: a user context (which ends with a _u), a role context (which ends with a _r), a type context (which ends with a _t), a sensitivity context, and a category set. The rules of the targeted policy are mostly associated with the type (_t) context.

Restrict all new users to the `user_u` user role by default: `semanage login -m -S targeted -s "user_u" -r s0 __default__`

This command modifies (-m) the targeted policy store (-S), with SELinux user (-s) user_u, with the MLS s0 range (-r) for the default user.

| **User Context** | **Features**                                                                                       |
| :--------------- | :------------------------------------------------------------------------------------------------- |
| guest_u          | No GUI, no networking, no access to **su** or **sudo** command, no file execution in /home or /tmp |
| xguest_u         | GUI, networking only via the Firefox web browser, no file execution in /home or /tmp               |
| user_u           | GUI and networking available                                                                       |
| staff_u          | GUI, networking, and the **sudo** command avaialble                                                |
| sysadm_u         | GUI, networking, and the **sudo** and **su** command available                                     |
| unconfined_u     | Full system access                                                                                 |

#### Manage SELinux Boolean Settings