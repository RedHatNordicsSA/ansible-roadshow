# Writing the Wildfly playbook

In this lab, you'll start the real work and deploy a wildfly swarm application to a number of servers. Running wildfly swarm is a bit different than running traditional application servers. You package your application into a fat jar file, which you run from the command line. The jar file is very small (measured in MB) and only contains the libraries necessary to run your application. In order to ensure that your application is easily maintainable and that it'll come up in the case of a server restart, you'll register the application as a service using systemctl.

For this excercise we assume that you've already packaged your application, using maven and pushed it to Nexus. From there you've pulled the file to the location *$LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar*

In order to ensure that you don't end up with a large unmaintainable yaml-file, the lead architect of your company has decided that you must structure your playbook using [roles](http://docs.ansible.com/ansible/latest/playbooks_reuse_roles.html). Roles is a way to structure your playbook around different aspects of your configuration. In this case, you will make a role for your wildfly applicationand only apply that role to your wildflyservers.

In *$WORK_DIR* create a new folder called *lab3*. Furthermore copy the jar file to a binary folder.

```
$mkdir -p $WORK_DIR/lab3/binaries
$cp $LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar $WORK_DIR/lab3/binaries
```

Create the rest of the structure for creating the playbook

```
$cd $WORK_DIR/lab3
$mkdir -p roles/wildflyapp/files
$mkdir roles/wildflyapp/tasks
```

In the folder *$WORK_DIR/lab3/roles/wildflyapp/tasks* create a file named main.yml. This file will contain the tasks needed to configure the wildfly application on the server. Paste the following into the file:

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

As you can see, starting a wildfly swarm application is pretty simple. Copy the jar file to the server, create a service script and run the application. We need to create the service script to be copied to the server. To do so, create a new file named *wildflyapp.service* at location *$WORK_DIR/lab3/roles/wildflyapp/files/*. Put the following content in the file:

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

Finally you need to apply the newly created role to your *wildflyservers* group. In dir *$WORK_DIR/lab3* create a file named *site.yml*. Put the following content into the file:

```
---
- hosts: wildflyservers
  user: "{{host_user}}"
  become: true
  tasks:
  - include_role:
      name: wildflyapp
```

As you can see we now include the role *wildflyapp* for all *wildflyservers*. We use a parameter to control the name of the user looging into the host.

Now you can run the playbook with the command:

```
$ansible-playbook --extra-vars "host_user=$MY_HOST_USER" site.yml
```

Now you can access the service at the address *http://$HOSTNAME:8080*.

Explain that code has been pushed to both servers.


Go through building the example

Explain running first -> access service

Explain running twice -> idempotens

```
Jacobs-MacBook-Pro-2:lab-files jacobborella$ ansible-playbook -i /tmp/hosts main.yaml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.211.55.23]

TASK [wildflyapp : Create directory to store binary] ***************************
changed: [10.211.55.23]

TASK [wildflyapp : Copy jar file to the server] ********************************
changed: [10.211.55.23]

TASK [wildflyapp : Create service script] **************************************
changed: [10.211.55.23]

TASK [wildflyapp : Reload systemd] *********************************************
ok: [10.211.55.23]

TASK [wildflyapp : Enable wildfly app service script] **************************
ok: [10.211.55.23]

TASK [wildflyapp : Make sure the wildfly app service is running] ***************
changed: [10.211.55.23]

PLAY RECAP *********************************************************************
10.211.55.23               : ok=7    changed=4    unreachable=0    failed=0   

Jacobs-MacBook-Pro-2:lab-files jacobborella$ ansible-playbook -i /tmp/hosts main.yaml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [10.211.55.23]

TASK [wildflyapp : Create directory to store binary] ***************************
ok: [10.211.55.23]

TASK [wildflyapp : Copy jar file to the server] ********************************
ok: [10.211.55.23]

TASK [wildflyapp : Create service script] **************************************
ok: [10.211.55.23]

TASK [wildflyapp : Reload systemd] *********************************************
ok: [10.211.55.23]

TASK [wildflyapp : Enable wildfly app service script] **************************
ok: [10.211.55.23]

TASK [wildflyapp : Make sure the wildfly app service is running] ***************
ok: [10.211.55.23]

PLAY RECAP *********************************************************************
10.211.55.23               : ok=7    changed=0    unreachable=0    failed=0   

```
