# Chapter 2 Notes

## KVM

- The following kernel modules are associated with KVM: `kvm`, `kvm_intel`, and `kvm_amd`.

- The GUI tool for managing KVM VMs is the Virtual Machine Manager. `# virt-manager`

- The default directory for Virtual Machine Manager's images is `/var/lib/libvirt/images`

### Install KVM

```bash
yum -y install qemu-kvm libvirt libvirt-client virt-install virt-manager virt-top virt-viewer
```

or

```bash
yum -y group install "Virtualization Host" "Virtualization Client"
```

### Loading the Kernel Modules

Ensure that the appropriate modules are loaded

`# lsmod | grep kvm`

If the proper modules are loaded you should see 'kvm' and 'kvm_intel or kvm_amd' in the output text.

You may manually load these modules using the following command:

`# modprobe kvm_intel or kvm_amd`

### CLI Create New Virtual Machine

```bash
virt-install -n server1.example.org --ram=1024 --vcpus=2 \
--disk path=/var/lib/libvirt/images/server1.example.org.img,size=16 \
--graphics=spice \
--location=ftp://10.13.33.31/pub/inst \
--os-type=linux \
--os-variant=rhel7
```

## Kickstart

- On a host, `/root/anaconda-ks.cfg` is a Kickstart config that represents the host's baseline installation.

### Verify the syntax of a Kickstart config

`ksvalidator <PATH_TO_CONFIG>`

### Build a Config file using the Kickstart Configurator GUI

#### Install

`# yum install system-config-kickstart`

#### Prelaoad the GUI with an existing config

> you might want to perform a backup of the config file before doing this

`# system-config-kickstart <PATH_TO_CONFIG>`

## SSH

The system ssh-client config is located in the following directory: `/etc/ssh/ssh_config`

## Remote Administration Testing Tools

useful tools for testing the functionality of a service on a remote system

- telnet & nmap: verify remote access to open ports
- mutt & mail: an e-mail client that can verify an en e-mail server
- elinks: a web browser that makes sure web services are available
- lftp: to access FTP servers

### telnet

connecting to ftp with telnet: `telnet localhost 21`

### nmap

scan localhost: `nmap localhost`

### mutt

test POP: `mutt -f pop://username@host`

### mail

send an email (if SMTP is available): `mail -s 'subject' < <FILE> <RECIPIENT>`

### elinks

viewing an ftp server: `elinks <URL>`

### lftp

connect to ftp server: `lftp <URL>`
