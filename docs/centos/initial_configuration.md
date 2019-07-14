# CentOS 7 - Initial Configuration

```bash
TIMEZONE=America/Chicago
PACKAGES="htop vim wget firewalld ntp yum-cron"

sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install $PACKAGES

# Configure Firewall
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
sudo systemctl enable firewalld

# Configure NTP
sudo timedatectl set-timezone $TIMEZONE
sudo systemctl start ntpd
sudo systemctl enable ntpd

# Configure Updates
sudo sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
```
