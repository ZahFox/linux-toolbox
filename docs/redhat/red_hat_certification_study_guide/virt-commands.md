# libvirt commands

> https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html

## Virt Install

### Headless

```bash
virt-install \
--name centos7 \
--ram 1024 \
--disk path=./centos7.qcow2,size=8 \
--vcpus 1 \
--os-type linux \
--os-variant centos7.0 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://mirror.i3d.net/pub/centos/7/os/x86_64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```

### GUI

```bash
virt-install \
  --name server1 \
  --ram 2048 \
  --disk path=/var/lib/libvirt/images/server1.example.com.img,size=16 \
  --vcpus 2 \
  --os-type linux \
  --os-variant centos7.0 \
  --network bridge=virbr0 \
  --graphics none \
  --console pty,target_type=serial \
  --location 'ftp://10.13.33.20/inst'
```

## Virt Clone

```bash
virt-clone \
  --original server1 \
  --name clone1 \
  --file /var/lib/libvirt/images/clone1.example.com.img
```
