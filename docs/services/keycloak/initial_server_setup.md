# Initial Keycloak Server Setup

## Pregame

```bash
sudo yum -y install epel-release wget gunzip vim firewalld
sudo yum -y update
sudo systemctl enable firewalld && sudo systemctl start firewalld
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload
```

## Install JDK

```bash
cd /tmp
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.tar.gz
sudo tar zxf jdk-10.0.2_linux-x64_bin.tar.gz -C /usr/local
sudo mv /usr/local/jdk-10.0.2 /usr/local/jdk-10
sudo alternatives --install /usr/bin/java java /usr/local/jdk-10/bin/java 2
sudo alternatives --set java /usr/local/jdk-10/bin/java
sudo alternatives --install /usr/bin/jar jar /usr/local/jdk-10/bin/jar 2
sudo alternatives --install /usr/bin/javac javac /usr/local/jdk-10/bin/javac 2
sudo alternatives --set jar /usr/local/jdk-10/bin/jar
sudo alternatives --set javac /usr/local/jdk-10/bin/javac
echo 'export JAVA_HOME=/usr/local/jdk-10' | sudo tee -a /etc/environment
source /etc/environment
sudo sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/urandom/' $(find $JAVA_HOME -name "java.security")
```

## Install Keycloak

```bash
cd /opt
sudo wget https://downloads.jboss.org/keycloak/4.4.0.Final/keycloak-4.4.0.Final.zip
sudo gunzip keycloak-4.4.0.Final.zip
sudo ln -s keycloak-4.4.0.Final/ keycloak
sudo rm keycloak-4.4.0.Final.zip
```

## Install MariaDB

### CentOS 7

```bash
sudo touch /etc/yum.repos.d/MariaDB.repo
echo -e "[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3.9/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" | sudo tee /etc/yum.repos.d/MariaDB.repo
sudo yum -y update
sudo yum -y install MariaDB-server MariaDB-client
sudo systemctl enable mariadb.service && sudo systemctl start mariadb.service
```

### Ubuntu 18.04

```bash
sudo apt-get -y install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/10.3/ubuntu bionic main'
sudo apt -y update
sudo apt -y install mariadb-server mariadb-client
sudo systemctl enable mariadb.service && sudo systemctl start mariadb.service
```

## Secure MariaDB

```bash
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('password') WHERE User = 'root'"
sudo mysql -e "DROP USER ''@'localhost'"
sudo mysql -e "DROP USER ''@'$(hostname)'"
sudo mysql -e "DROP DATABASE test"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -e "FLUSH PRIVILEGES"
```

## Create the Keycloak Database and Database User

```bash
echo -e "SELECT * FROM information_schema.TABLE_STATISTICS;
CREATE USER 'keycloak'@'%' IDENTIFIED BY 'keycloak';
CREATE DATABASE keycloak CHARACTER SET utf8 COLLATE utf8_unicode_ci;
GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'%';" | sudo mysql -u root -ppassword
```

## Install MariaDB JDBC Driver Module for Keycloak

```bash
wget -P /tmp/ https://downloads.mariadb.com/Connectors/java/connector-java-2.3.0/mariadb-java-client-2.3.0.jar
gunzip /tmp/mariadb-java-client-2.3.0.jar -d /tmp
sudo mkdir -p /opt/keycloak/modules/system/layers/base/org/mariadb/main
sudo cp /tmp/mariadb-java-client-2.3.0.jar /opt/keycloak/modules/system/layers/base/org/mariadb/main

echo -e "<?xml version=\"1.0\" ?>
<module xmlns=\"urn:jboss:module:1.3\" name=\"org.mariadb\">
 <resources>
  <resource-root path=\"mariadb-java-client-2.3.0.jar\" />
 </resources>
 <dependencies>
  <module name=\"javax.api\"/>
  <module name=\"javax.transaction.api\"/>
 </dependencies>
</module>" > /tmp/module.xml

sudo cp /tmp/module.xml /opt/keycloak/modules/system/layers/base/org/mariadb/main/module.xml

echo -e "embed-server --server-config=standalone.xml
/subsystem=datasources/jdbc-driver=mariadb:add(driver-name=mariadb,driver-module-name=org.mariadb,driver-class-name=org.mariadb.jdbc.Driver,driver-xa-datasource-class-name=org.mariadb.jdbc.MariaDbDataSource)" > /tmp/configure-db-driver.cli

sudo /opt/keycloak/bin/jboss-cli.sh --file=/tmp/configure-db-driver.cli

echo -e "embed-server --server-config=standalone.xml
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=driver-name,value=mariadb)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=connection-url,value=\"jdbc:mariadb://localhost:3306/keycloak?characterEncoding=UTF-8\")
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=exception-sorter-class-name,value=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=valid-connection-checker-class-name,value=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=password,value=keycloak)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=user-name,value=keycloak)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=validate-on-match,value=true)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=background-validation,value=false)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=enabled,value=true)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=max-pool-size,value=20)
/subsystem=datasources/data-source=KeycloakDS/:write-attribute(name=min-pool-size,value=5)" > /tmp/configure-datasource.cli

sudo /opt/keycloak/bin/jboss-cli.sh --file=/tmp/configure-datasource.cli
```

## Install and Configure Nginx Part 1

> Place any Nginx configuration files in /tmp

```bash
echo -e '[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1' | sudo tee /etc/yum.repos.d/nginx.repo

sudo yum -y update && sudo yum -y install nginx
sudo systemctl enable nginx.service && sudo systemctl start nginx.service
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.$(date "+%Y-%m-%d_%H:%M").conf
sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf
sudo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
sudo mv /tmp/site.part1 /etc/nginx/sites-available/site
sudo ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site
sudo systemctl restart nginx
```

## Generate SSL/TLS Certificates with Let's Encrypt and Certbot

```bash
sudo yum -y install python2-certbot-nginx
sudo certbot --nginx
sudo certbot certonly --nginx -d example.com --non-interactive --agree-tos -m zahfox@example.com
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```

## Install and Configure Nginx Part 2

```bash
sudo mkdir -p /etc/nginx/snippets
sudo mv /tmp/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
sudo mv /tmp/ssl-example.com.conf /etc/nginx/snippets/ssl-example.com.conf
sudo mv /tmp/site.part1 /etc/nginx/sites-available/site
sudo systemctl restart nginx.service
```
