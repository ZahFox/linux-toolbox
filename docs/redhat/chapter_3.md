# Chapter 3 - Fundamental Command-Line Skills

## Shells

Change a user's default shell to `zsh`.

```bash
yum -y install zsh

function escape {
  echo $1 | sed -e 's/\//\\\//g'
}

USER=student
OLD=$(grep -E "^$USER.*/bin/bash\$" /etc/passwd)
NEW=$(echo $OLD | sed -e 's/\/bin\/bash/\/bin\/zsh/')
sed -i "s/$(escape $OLD)/$(escape $NEW)/" /etc/passwd
```

## Text Streams and Command Redirection

Redirect the standard error to a file: `# program 2> err-list`
Ignore standard error: `# program 2> /dev/null`
Redirect standard input and error `# program &> output-and-error`

## File Searches

Find the example BIND file: `# find /usr -name named.conf`

Manually update the `locate` database: `# /etc/cron.daily/mlocate`

## Managing Text Files

List the types of file in the `cwd`: `# file *`

Use the `sort` command to sort input streams.

Use the `-e` option in `grep` to search with multiple patterns like so: `# grep -v -e '^$' -e '^#' /etc/nsswitch.conf`

### Diffing Files

```bash
diff /root/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-eth0
```

## Getting Help for Commands

> RTFM!

Searching for man pages by title contents: `# whatis <SEARCH_TERM>`
Searching for man pages by description contents: `# apropos <SEARCH_TERM>`

Update the index for these search commands: `# /etc/cron.daily/man-db.cron`

List the info pages avaiable on the system: `# ls /usr/share/info`
Read the `bash` info page: `# pinfo bash`

## Basic Networking Commands

> By default, Red Hat Enterprise Linux 7 names network interfaces based on their physical location (enoX and emX for onboard network interfaces, and enpXsY and pXpY for PCI slots).

### Common IP Commands

> All changes made with the `ip` command are temporary only

`ip addr` - Shows the link status and IP address information for all network interfaces
`ip addr add <IP/CIDR_NETMASK> dev <INTERFACE_NAME>` - Assigns an IP address and netmask to a network interface
`ip neigh` - Shows the ARP table
`ip route` - Displays the routing table
`ss -tupna` - Shows all listening and non-listening sockets, along with the program to which they belong

show the active network interfaces - `ip link show`

#### Set an interface up or down

- temporary

`# ip link set dev <INTERFACE_NAME> <[UP | DOWN]>`

- permanently

`# ifup <INTERFACE_NAME>`

`# ifdown <INTERFACE_NAME>`

### dhclient

Request DHCP information for a network interface `# dhclient <INTERFACE_NAME>`

## Basic Network Configuration

> Many network configuration files are found in the following directory: `/etc/sysconfig/network-scripts`

Check the status of the network: `# systemctl status network`
Check if the NetworkManager is running: `# systemctl status NetworkManager`

> NetworkManager is controller using nmcli

List status of network devices `# nmcli dev status`

### nmcli commands

reload configs: `# nmcli con reload`

set interface down: `# nmcli con down <INTERFACE_NAME>`

set interface up: `# nmcli con up <INTERFACE_NAME>`

create a connection profile: `# nmcli con add con-name <PROFILE_NAME> type ethernet ifname <INTERFACE_NAME>`

configure static IP: `# nmcli con mod <PROFILE_NAME> ipv4.addresses "<IP/CIDR_NETMASK> <DEFAULT_GATEWAY>"`

configure DNS: `# nmcli con mod <PROFILE_NAME> +ipv4.dns <IP_ADDRESS>`

activate connection profile: `# nmcli con up <PROFILE_NAME>`

#### Complete nmcli profile

```bash
nmcli con add con-name "<PROFILE_NAME>" ifname <INTERFACE_NAME> type ethernet ip4 <IPV4_ADDRESS>/<CIDR> gw4 <DEFAULT_GATEWAY>
nmcli con mod "<PROFILE_NAME>" ipv4.dns "<DNS_IPV4_ADDRESS>,8.8.8.8"
nmcli con up "<PROFILE_NAME>" iface <INTERFACE_NAME>
```

### local DNS

`/etc/nsswitch.conf` - Specifies the database search priorities for everything from authentication to name services. The `hosts: files dns` entry determines the first database to search for name resolution.

`/etc/hosts` - IP to hostname mappings

`/etc/resolv.conf` - DNS server lcoations
