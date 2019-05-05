# System Setup Options

## Permantely enable IP forwarding

Add `net.ipv4.ip_forward = 1` to `/etc/sysctl.conf`
and then run `# sysctl -p`

## Mount an installation CD to /media

`# mount /dev/cdrom /media`

## Mount an ISO image

`# mount -ro loop rhel-server-7.0-x86_64-dvd.iso /media`

## Recursively copy the SELinux context from a directory

`# chcon -R --reference=<ORIGIN> <DESTINATION>`

## Make the contents of a directory public with SELinux

`# chcon -R -t public_content_t /var/ftp/`

## Enable FTP in the firewall

```bash
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
```

## Enable HTTP in the firewall

```bash
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

## Key Points

- If you're studying for the RHCSA, focus on Chapters 1-9. If you're studying for the RHCE, although you're responsible for the information in the entire book, focus on Chapters 1-2 and 10-17.
