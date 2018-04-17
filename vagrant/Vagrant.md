# How to set up local env using Vagrant

NOTE: tested with MacOS and VirtualBox only. May work with other envs as well.

Prerequisites:  Make sure you have a ssh key pair in your $HOME/.ssh/id_rsa(.pub), it will be used with ansible.

Install [Vagrant](https://www.vagrantup.com).

This will use VirtualBox (see [www.virtualbox.org](https://www.virtualbox.org) for installation instructions).

Run ```vagrant up```

It will create 3 Virtualbox vm's:  3 nodes with (1G RAM, IPs 10.42.0.6-8).

After that you should go to directory "ansible" and run:
```ansible-playbook -i hosts -l machines setup.yml```
To have EPEL repo enabled on those hosts.

If you want to have Tower as well
Run ```vagrant up ansible-tower```

It will create one for ansible tower (2G RAM, IP 10.42.0.2)

After that go to ansible directory and run:

NOTE: this will take 10-15 minutes!

```ansible-playbook -i hosts -l tower setup.yml tower.yml```

After this you should be able to login to https://10.42.0.2/ using testuser/foobarbaz

# Inventory file for labs

[lbservers]
10.42.0.6

[wildflyservers]
10.42.0.7
10.42.0.8