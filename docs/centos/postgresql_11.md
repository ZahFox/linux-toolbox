# CentOS 7 - postgresql 11

## Install

```bash
sudo rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y install postgresql11-server
sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
sudo sed -i 's/ident/md5/g' /var/lib/pgsql/11/data/pg_hba.conf
sudo systemctl enable postgresql-11.service
sudo systemctl start postgresql-11.service
```

## CLI Examples

### Create a new Role, Database, and Table

```bash
sudo adduser proto
sudo -i -u postgres
createuser proto
createdb proto
psql -d proto -c 'CREATE TABLE proto (id serial PRIMARY KEY, date_created date, name varchar(50) NOT NULL);'
```

### Creating a Table with Referential Integrity

```sql
CREATE TABLE cities (
        city     varchar(80) primary key,
        location point
);

CREATE TABLE weather (
        city      varchar(80) references cities(city),
        temp_lo   int,
        temp_hi   int,
        prcp      real,
        date      date
);
```
