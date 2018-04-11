# How to set up local env using Vagrant

```vagrant up```
Will create 4 virtualbox vm's: one for ansible tower (2G) and 3 nodes.

After that you should go to directory "ansible" and run:
```ansible-playbook -i inventory.ini setup.yml```
To have EPEL repo enabled on those hosts.
