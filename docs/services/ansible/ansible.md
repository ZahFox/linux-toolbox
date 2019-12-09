# Ansible

## Install

### Arch Linux

```bash
sudo pacman -Syu ansible
```

## Configuration

The main configuration file should be at `/etc/ansible/ansible.cfg`

You can override any value loaded from the configuration file using environment variables

You might want to edit the enable inventory plugins in `/etc/ansible/ansible.cfg`

> On arch linux you will need the `python-botocore` and `python-boto3` packages installed

```cfg
[inventory]
enable_plugins = host_list, virtualbox, yaml, script, toml, aws_ec2
```

### Host and Group Inventory

Hosts and groups can be given variables in separate files. If an inventory file at `/etc/ansible/hosts` contains a host named 'foosball' that belongs to two groups, 'raleigh' and 'webservers', that host will use variables in YAML files at the following locations:

```txt
/etc/ansible/group_vars/raleigh
/etc/ansible/group_vars/webservers
/etc/ansible/host_vars/foosball
```

Each of these locations can also be a directory with separate variable files e.g., `/etc/ansible/group_vars/raleigh/db_settings`

#### Variable Merging Precedence (lowest to highest)

- all group (this is the root group)
- parent group
- child group
- host

## Concepts

- Hosts and other resources are identified using inventory files
- Desired states are achieved using **Playbooks**.
- **Playbooks** contain sequentially run **tasks** which use **modules**.
- **Handlers** are run once, at the end of plays.

## Usage

### Bootstrapping Python on a Client System

```bash
ansible <HOST> -u ec2-user --become -m raw -a "yum install -y python2"
```
