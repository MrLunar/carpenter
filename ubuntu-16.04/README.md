# Carpenter - Ubuntu 16.04

This sub-project contains all the resources required to build and distribute Ubuntu 16.04 images. 

This is currently just Vagrant boxes.


## Pre-Requisites 

You will need all the following software installed on your workstation to build all VM images:

  - [Virtualbox](https://www.virtualbox.org/) ~5.1.22
  - [Packer](https://www.packer.io/) ~1.0.0
  - [Vagrant](https://www.vagrantup.com/) ~v1.9.4
  - A terminal running Bash (Git Bash is fine for Windows)

The versions are what these templates have been tested against. Your mileage may vary against other versions.


## Getting Started

### Base Images

First we build a fresh install straight from the original installation media:

```
PACKER_CACHE_DIR=../packer_cache packer build server-base.json
```

Build an updated version of the base image:

```
packer build server-baseupdates.json
```

Configuration management clients are also base images:

```
packer build server-chef12.json
```

We can now create environment-specific images from these base images.


### Vagrant

Build vagrant boxes:

```
packer build -var-file=vars/server-vagrant-nocm.vars.json server-vagrant.json
```
```
packer build -var-file=vars/server-vagrant-chef12.vars.json server-vagrant.json
```

Import these boxes locally:

```
vagrant box add --force --name test/ubuntu-16.04-server ../output/ubuntu-16.04/vagrant/ubuntu-16.04-server-vbox.box
```
```
vagrant box add --force --name test/ubuntu-16.04-server-chef12 output/ubuntu-16.04/vagrant/ubuntu-16.04-server-chef12-vbox.box
```

You can now run and test these local boxes:

```
vagrant up server
```
```
vagrant up server-chef12
```

After testing these boxes, they can be uploaded to Atlas if desired: https://atlas.hashicorp.com/vagrant
