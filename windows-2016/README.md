# Carpenter - Windows Server 2016

This sub-project contains all the resources required to build and distribute Windows Server 2016 images. 

This is currently just Vagrant boxes.


## Base Images

First we build a fresh install straight from the original installation media:

```
packer build desktop-base.json
```

Now we can update the base image with the latest updates. WARNING: This stage will take quite some time due to the nature of Windows Updates.

```
packer build desktop-baseupdates.json
```


## Vagrant

Build vagrant boxes:

```
packer build -var-file=vars/desktop-vagrant-nocm.vars.json desktop-vagrant.json
```

Import boxes to test:

```
vagrant box add --force --name test/windows-2016-desktop ../output/windows-2016/vagrant/windows-2016-desktop-vbox.box
```

Test vagrant boxes:

```
vagrant up desktop
```

After testing these boxes, they can be uploaded to Atlas if desired: https://atlas.hashicorp.com/vagrant
