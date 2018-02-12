# Getting started

You are the operator at tangible labs inc and tasked with setting up servers for the compagnys new application, based on wildfly-swarm. After attending several sessions on automation, you've decided to give Ansible a go.

The first lab will help you verifying the Ansible installation and getting aquainted with basic Ansible concepts.

First let's verify that Ansible has been installed. On the commandline run the following command:

```
$ansible --version
```

you should see an output like the following

```
$ansible --version
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u\'/root/.ansible/plugins/modules\', u\'/usr/share/ansible/plugins/modules\']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, May  3 2017, 07:55:04) [GCC 4.8.5 20150623 (Red Hat 4.8.5-14)]
```

As you can see Ansible uses python. If you inspect the config file (/etc/ansible/ansible.cfg) file, you will find the following configuration

```
[defaults]

# some basic default values...

#inventory      = /etc/ansible/hosts
#library        = /usr/share/my_modules/
#module_utils   = /usr/share/my_module_utils/
```

most important for a beginning is the default location of the inventory file. The inventory file contains a list of the servers, you are managing. The servers can be grouped in any way you like. For this lab, group the servers into load balancers (lbservers) and wildfly swarm application servers (wildflyservers). To do so at the end of the inventory file, add the following text

```
[lbservers]
35.159.18.245

[wilflyservers]
54.93.67.223
54.93.150.126
```

you are now ready to run your first Ansible module. To do so, run the following command:

```
ansible all -m ping
```

this will give the following output

```
35.159.18.245 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
54.93.67.223 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
54.93.150.126 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

Congratulations! You've run your first Ansible command.
For a more detailed explanation of, what is going on, try running

```
ansible all -vvv -m ping
```

Basically the command will ssh to each host and run the command *echo \'pong\' on the host. The result is captured by Ansible in a return variable.

In the next lab, you'll write your first playbook, using the ping module, to get a better understanding of how Ansible works.
