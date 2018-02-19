# Writing the Wildfly playbook

In this lab, you'll start the real work and deploy a wildfly swarm application to a number of servers. Running wildfly swarm is a bit different than running traditional application servers. You package your application into a fat jar file, which you run from the command line. The jar file is very small (measured in MB) and only contains the libraries necessary to run your application. In order to ensure that your application is easily maintainable and that it'll come up in the case of a server restart, you'll register the application as a service using systemctl.

For this excercise we assume that you've already packaged your application, using maven and pushed it to Nexus. From there you've pulled the file to the location *$LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar*

In order to ensure that you don't end up with a large unmaintainable yaml-file, the lead architect of your company has decided that you must structure your playbook using [roles](http://docs.ansible.com/ansible/latest/playbooks_reuse_roles.html). Roles is a way to structure your playbook around different aspects of your configuration. In this case, you will make a role for your wildfly application and only apply that role to your wildflyservers.

In *$WORK_DIR* copy the jar file to a binary folder.

```
$mkdir -p $WORK_DIR/binaries
$cp $LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar $WORK_DIR/binaries
```

Create the rest of the structure for creating the playbook

```
$cd $WORK_DIR
$mkdir -p roles/wildflyapp/files
$mkdir roles/wildflyapp/tasks
```

In the folder *$WORK_DIR/roles/wildflyapp/tasks* create a file named main.yml. This file will contain the tasks needed to configure the wildfly application on the server. Paste the following into the file:

```
---
- name: Create directory to store binary
  file:
    path: /opt/wildflyapp
    state: directory
- name: Copy jar file to the server
  copy:
    src: binaries/example-jaxrs-war-swarm.jar
    dest: /opt/wildflyapp/example-jaxrs-war-swarm.jar
    owner: "{{host_user}}"
    group: "{{host_user}}"
    mode: 0644
- name: Create service script
  copy:
    src: roles/wildflyapp/files/wildflyapp.service
    dest: /lib/systemd/system/wildflyapp.service
    owner: root
    group: root
    mode: 0644
- name: Reload systemd
  systemd:
    daemon_reload: yes
- name: Enable wildfly app service script
  systemd:
    name: wildflyapp
    enabled: no
    masked: no
- name: Make sure the wildfly app service is running
  systemd: state=started name=wildflyapp
``` 

As you can see, starting a wildfly swarm application is pretty simple. Copy the jar file to the server, create a service script and run the application. We need to create the service script to be copied to the server. To do so, create a new file named *wildflyapp.service* at location *$WORK_DIR/roles/wildflyapp/files/*. Put the following content in the file:

```
[Unit]
Description=Wildfly Swarm Application Script
After=auditd.service systemd-user-sessions.service time-sync.target
 
[Service]
User=root
TimeoutStartSec=0
Type=simple
KillMode=process
WorkingDirectory=/opt/wildflyapp
ExecStart=/bin/java -jar /opt/wildflyapp/example-jaxrs-war-swarm.jar
Restart=always
RestartSec=2
LimitNOFILE=5555
 
[Install]
WantedBy=multi-user.target
```

Finally you need to apply the newly created role to your *wildflyservers* group. In dir *$WORK_DIR* create a file named *site.yml*. Put the following content into the file:

```
---
- hosts: wildflyservers
  user: "{{host_user}}"
  become: true
  tasks:
  - include_role:
      name: wildflyapp
```

As you can see we now include the role *wildflyapp* for all *wildflyservers*. We use a parameter to control the name of the user logging into the host.

Now you can run the playbook with the command:

```
$ansible-playbook --extra-vars "host_user=$MY_HOST_USER" site.yml
```

You should see Ansible executing the playbook. At the end of the Ansible output there is a recap of how running the playbook went:

```
PLAY RECAP *********************************************************************
10.211.55.23               : ok=7    changed=4    unreachable=0    failed=0   
10.211.55.25               : ok=7    changed=4    unreachable=0    failed=0   
```

Ansible should complete with no errors. You should see the changes applied to both wildfly swarm servers.

You can now access the service at the address *http://$HOSTNAME:8080*, where *$HOSTNAME* points to one of the servers mentioned in the play recap.

Try running the playbook again. This time you'll get a different output:

```
PLAY RECAP *********************************************************************
10.211.55.23               : ok=7    changed=0    unreachable=0    failed=0   
10.211.55.25               : ok=7    changed=0    unreachable=0    failed=0   
```

Modules in Ansible are idempotent, ensuring that no matter how many times you run the playbook, the result on the server will be the same. Thus on the second run, Ansible detected that no changes were necessary, since the servers were already in the wanted state and thus didn't apply any changes. This is a cool feature of Ansible. For instance if you want to add an extra server, just add the server to the hosts file and run the playbook again without worrying about the existing servers.

