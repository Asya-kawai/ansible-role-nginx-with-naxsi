# Ansible Role For Nginx Setting

Setup nginx.

# Examples

Directory tree.

```
.
├── README.md
├── ansible.cfg
├── etc
│   └── nginx
│       ├── centos
│       │   ├── conf.d
│       │   │   ├── your-domain-example.com.conf
│       │   ├── html
│       │   │   └── index.html
│       │   ├── mime.types
│       │   └── nginx.conf
│       └── ubuntu
│           ├── conf.d
│           │   └── your-domain-example.com.conf
│           ├── html
│           │   └── index.html
│           ├── mime.types
│           └── nginx.conf
├── group_vars
│   ├── all.yml
│   ├── webserver_centos.yml
│   └── webserver_ubuntu.yml
├── inventory
└── webservers.yml
```

## Inventory file

```
[webservers:children]
webserver_ubuntu
webserver_centos

[webserver_ubuntu]
ubuntu ansible_host=10.10.10.10 ansible_port=22

[webserver_centos]
centos ansible_host=10.10.10.11 ansible_port=22
```

## Group Vars / Common settings(all.yml)

`all.yml` sets common variables.

```
# Common settings
become: yes
ansible_user: root

# Private_key is saved in local host only!
ansible_ssh_private_key_file: ""
```

## Group Vars / Ubuntu(webserver_ubuntu.yml)

`webserver_ubuntu.yml` is `webservers` host's children.
This role does NOT need to define any variables.

## Group Vars / CentOS(webserver_centos.yml)

`webserver_ubuntu.yml` is `webservers` host's children.
This role does NOT need to define any variables.

## Playbook / Webservers(webservers.yml)

```
- hosts: webservers
  become: yes
  module_defaults:
    apt:
      cache_valid_time: 86400
  roles:
    - user
```

## Nginx conf files

This role copy some config files(`nginx.conf`, `mime.types`, `conf.d/*` and `html/*`) in `/usr/loca/etc/nginx/`.

So when you want to copy these files to `ubuntu`(ubuntu is inventory's host name),
you should make `./etc/nginx/ubuntu/{nginx.conf, mime.types, conf.d/, html/}`.

```
etc/nginx/ubuntu/
├── conf.d
│   ├── your-domain-example.com.conf
├── html
│   └── index.html
├── mime.types
└── nginx.conf
```

# How to DryRun and Apply

DryRun

```
ansible-playbook -i inventory --private-key="~/.ssh/your_private_key" -CD webservers.yml --tags nginx
```

Apply

```
ansible-playbook -i inventory --private-key="~/.ssh/your_private_key" -D webservers.yml --tags nginx
```
