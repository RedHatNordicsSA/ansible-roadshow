# Getting started

_Ensure that you are logged in to your Ansible control server._

You are the operator at Tangible Labs Inc. and tasked with setting up servers for the company's new application that's based on wildfly-swarm. After attending several sessions on automation, you've decided to give Ansible a go.

The first lab will help you verifying the Ansible installation and getting acquainted with basic Ansible concepts.

But first, let's verify that Ansible has been installed. On the commandline run the following command:

```
$ansible --version
```

You should see output like the following:

```
$ansible --version
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u\'/root/.ansible/plugins/modules\', u\'/usr/share/ansible/plugins/modules\']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, May  3 2017, 07:55:04) [GCC 4.8.5 20150623 (Red Hat 4.8.5-14)]
```

As you can see Ansible uses python. If you inspect the config file (/etc/ansible/ansible.cfg) file, you will find the following configuration:

```
[defaults]

# some basic default values...

#inventory      = /etc/ansible/hosts
#library        = /usr/share/my_modules/
#module_utils   = /usr/share/my_module_utils/
```

The most important for a beginning is the default location of the inventory file. The inventory file contains a list of servers that you are managing. The servers can be grouped in any way you like. For this lab, group the servers into load balancers (lbservers) and wildfly swarm application servers (wildflyservers).

Before we continue on, make sure that the $WORK_DIR variable is defined. If $WORK_DIR is not defined, [take a look at the preparations.](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-0)
Now, create a file named *hosts* in the *$WORK_DIR* folder.

Please note: you got three servers assigned to you, it doesn't matter which one is put in the [lbservers] section and which remaining two are put in the [wildflyservers] section during lab 1.

Add the following text to the file:

```
[lbservers]
client_system_X

[wildflyservers]
client_systemY
client_systemZ
```
where X,Y,Z are replaced by the numbers for servers assigned to you.

Since this is the first time we're connecting to these servers, you'll need to accept the identity of the servers.
To speed up the process, we can use the ssh-keyscan command to accept identities. Like so:

```
ssh-keyscan -H client_systemX client_systemY client_systemZ >> ~/.ssh/known_hosts
```

You are now ready to run your first Ansible module. To do so, run the following command from *$WORK_DIR*

```
ansible -i hosts -u root all -m ping
```

This command will run the ping command on all servers in the hosts file (specified by -i). The -u parameter is used to sign into the servers as the root user. ** If the previous step failed, you might be asked to accept the identity of the servers.** Type yes for each server. After running the ping command, you'll have following output

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

Congratulations! :smile: :tada: You've run your first Ansible command.
For a more detailed explanation of what is going on, try running the same command but add the *-vvv* parameter

```
ansible -vvv -i hosts -u root all -m ping
```

Basically, the command will ssh to each host and run the ping module on the host. The result is captured by Ansible in a return variable. (If you are interested in the content of a module, see the source code for the ping module [in the github repo for modules](https://github.com/ansible/ansible-modules-core/blob/devel/system/ping.py). You don't have to. Modules will be covered in a later lab.)

In the next lab, you'll write your first playbook using the ping module to get a better understanding of how Ansible works.
