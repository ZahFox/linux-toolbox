# CentOS 7 - Initial Configuration

```bash
sudo yum -y install epel-release
sudo yum -y install htop vim wget firewalld ntp

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo systemctl enable firewalld

sudo timedatectl set-timezone America/Chicago
sudo systemctl start ntpd
sudo systemctl enable ntpd
```
