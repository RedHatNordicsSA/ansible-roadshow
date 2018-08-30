# Writing the WildFly playbook

In this lab, you'll start the real work and deploy a WildFly Swarm application to a number of servers. 
Let's overview which part of the system which you will be working on in this lab.

![Overview of lab environment](../../content/images/app-arch.png)

Running WildFly Swarm is a bit different than running traditional application servers. You package your application into a fat jar file, which you run from the command-line interface. The jar file is very small (measured in MB) and only contains the libraries necessary to run your application. In order to ensure that your application is easily maintainable and that it'll come up in the case of a server restart, you'll register the application as a service using systemctl.

For this excercise we assume that you've already packaged your application, using maven and pushed it to Nexus. From there you've pulled the file to the location *$LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar*

In order to ensure that you don't end up with a large unmaintainable yaml-file, the lead architect of your company has decided that you must structure your playbook using [roles](http://docs.ansible.com/ansible/latest/playbooks_reuse_roles.html). Roles is a way to structure your playbook around different aspects of your configuration. In this case, you will make a role for your WildFly application and only apply that role to your wildflyservers.

In *$WORK_DIR* copy the jar file to a binary folder.

```
mkdir -p $WORK_DIR/binaries
cp $LAB_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar $WORK_DIR/binaries
```

Create the rest of the structure for creating the playbook. You can use the Ansible Galaxy init functionality to easily create a template for your new role.

```
cd $WORK_DIR
ansible-galaxy init roles/wildflyapp
```
This will create a full structure for the WildFly role named *wildflyapp*. In the folder *$WORK_DIR/roles/wildflyapp/tasks* there is a file named main.yml. This file will contain the tasks needed to configure the WildFly application on the server. Add the nessicary tasks to install WildFly by pasting in below in a terminal:

```
cat << 'EOF' >$WORK_DIR/roles/wildflyapp/tasks/main.yml
---
# tasks file for roles/wildflyapp
- name: Install java
  yum:
    name: java
- name: Create directory to store binary
  file:
    path: /opt/wildflyapp
    state: directory
- name: Copy jar file to the server
  copy:
    src: binaries/example-jaxrs-war-swarm.jar
    dest: /opt/wildflyapp/example-jaxrs-war-swarm.jar
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
EOF
```

As you can see, starting a WildFly Swarm application is pretty simple. There is no need for a 1 GB app server with a million dependencies here. We only need to copy the jar file to the server, create a service script and run the application. But before we can start our application, we need to create the service script to be copied to the server. To do so, create a new file named *wildflyapp.service* at location *$WORK_DIR/roles/wildflyapp/files/*. Put the following content in the file:

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
  become: yes
  tasks:
  - include_role:
      name: wildflyapp
```

As you can see we now include the role *wildflyapp* for all *wildflyservers*. Please also note the line
```
  become: yes
```
This is because we need a bit more access in order to install software and enable services. This line means that Ansible will (in this case) call upon a software called sudo running on the target systems, to gain admin access when running these tasks. To read more about your ability to control privledge escalation, go here: https://docs.ansible.com/ansible/latest/user_guide/become.html

With this said, you can run the playbook with the command:

```
ansible-playbook -i hosts site.yml
```

You should see Ansible executing the playbook. At the end of the Ansible output there is a recap of how running the playbook went:
```
PLAY RECAP ****************************************************************
wildfly1                   : ok=8    changed=5    unreachable=0    failed=0   
wildfly2                   : ok=8    changed=5    unreachable=0    failed=0   
```

Ansible should complete with no errors. You should see the changes applied to both WildFly Swarm servers.

You can now access the service at the address *http://$HOSTNAME:8080*, where *$HOSTNAME* points to one of the servers mentioned in the play recap. Try it out by running below command:

```
curl http://111.222.333.444
```
Where 111.222.. is the IP address of one of your wildfly servers.

Example output should be:
```
$ curl http://18.197.135.122:8080
Howdy from unknown at 2018-08-30T22:25:09.897Z (from ip-172-31-25-165.eu-central-1.compute.internal)
```

Now, try running the playbook again. This time you'll get a different output:

```
PLAY RECAP ****************************************************************
wildfly1                   : ok=8    changed=0    unreachable=0    failed=0   
wildfly2                   : ok=8    changed=0    unreachable=0    failed=0 
```

Most modules in Ansible are idempotent, ensuring that no matter how many times you run the playbook, the result on the server will be the same. Thus on the second run, Ansible detected that no changes were necessary, since the servers were already in the wanted state and thus didn't apply any changes. This is a cool feature of Ansible. For instance if you want to add an extra server, just add the server to the hosts file and run the playbook again without worrying about the existing servers.

```
End of lab
```
[Go to the next lab, lab 4](../lab-4/README.md)
