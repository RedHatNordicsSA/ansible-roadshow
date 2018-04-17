# How to set up local env using Vagrant

Prerequisites:  Make sure you have a ssh key pair in your $HOME/.ssh/id_rsa(.pub), it will be used with ansible.

Install [Vagrant](https://www.vagrantup.com).

This will use VirtualBox (see [www.virtualbox.org](https://www.virtualbox.org) for installation instructions).

Run ```vagrant up```

It will create 3 Virtualbox vm's:  3 nodes with (1G RAM, IPs 10.50.0.6-8).

After that you should go to directory "ansible" and run:
```ansible-playbook -i hosts -l machines setup.yml ```
To have EPEL repo enabled on those hosts.

If you want to have Tower as well
Run ```vagrant up ansible-tower```

It will create one for ansible tower (2G RAM, IP 10.50.0.2)

After that go to ansible directory and run:

```ansible-playbook -i hosts -l tower setup.yml tower.yml```
