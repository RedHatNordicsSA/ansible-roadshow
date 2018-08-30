# Handling Secrets with Ansible Vault

Most applications have secret properties, which mustn't be shown for every person, working with the playbooks. The application you're working with is no exception, so you've been asked to set an environment variable named *SECRET_NAME* on the WildFly application servers for the application to work properly. Fortunately for you, this is pretty easy with Ansible.

With Ansible you can create property files and encrypt them afterwards. Once the property file has been encrypted, the content is unreadable. This has one unwanted effect, which is that you'll then be unable to search for the property. Therefore it's considered best practise to have an unencrypted file refer to the encrypted file. This is achieved with the following steps:

```
mkdir -p $WORK_DIR/group_vars/dev/wildflyservers
echo 'secret_name: "{{ vault_secret_name }}"' > $WORK_DIR/group_vars/dev/wildflyservers/vars.yml
echo 'vault_secret_name: Red Hat' > $WORK_DIR/group_vars/dev/wildflyservers/vault.yml
```

As you can see, some refactoring has been done to ensure, that it is possible to use different configurations for different environments. This is achieved by having different environment folders in the *group_vars* directory. In this case a dev profile is created by adding dev specific settings to the folder *$WORK_DIR/group_vars/dev/*. Servers can belong to several groups, so in the hosts file we can add a group *dev* with all servers listed. The *hosts* file should look like this:

```
[lbservers]
client_system_1 ansible_host=xxx.xxx.xxx.xxx

[wildflyservers]
client_system_2 ansible_host=yyy.yyy.yyy.yyy
client_system_3 ansible_host=zzz.zzz.zzz.zzz

[dev]
client_system_1 ansible_host=xxx.xxx.xxx.xxx
client_system_2 ansible_host=yyy.yyy.yyy.yyy
client_system_3 ansible_host=zzz.zzz.zzz.zzz
```

As before change machine names to those assigned to you.

Now Ansible will include all variables defined in *$WORK_DIR/group_vars/dev/* for the servers listed, each time the playbook is run.

Finally let's encrypt the vault file. In the prompt write:

```
ansible-vault encrypt $WORK_DIR/group_vars/dev/wildflyservers/vault.yml
```

enter a password of your choice when prompted and remember the password. This will encrypt your newly created file. Take a look at the content to ensure that it has in fact been encrypted.

Last step is to add the newly created variable as an environment variable to the playbook for the WildFly app role. At the same time we'll make some other changes. It's considered best practise to only set the environment variable locally for the wildflyapp service. Thus we are required to change the service script file from a static file to a template file in order to be able to change the secret name. Furthermore we want to restart the WildFly service in order to ensure that the service is restarted in case there are changes in the jar file or in the configuration. To do so, change the content of *$WORK_DIR/roles/wildflyapp/tasks/main.yml* to the following:

```
---
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
  register: jar_file_copy
- name: Create service script
  template:
    src: wildflyapp.template
    dest: /lib/systemd/system/wildflyapp.service
    owner: root
    group: root
    mode: 0644
  register: service_script_create
  no_log: true
- name: Reload systemd
  systemd:
    daemon_reload: yes
- name: Enable wildfly app service script
  systemd:
    name: wildflyapp
    enabled: yes
    masked: no
    state: started
  no_log: true
- name: Restart the wildfly app if there are any changes
  systemd: state=restarted name=wildflyapp
  when: jar_file_copy.changed or service_script_create.changed
  no_log: true
```
Remark the addition of no_log to ensure that no details about our secret is logged.

Rename the service script to reflect that it is now a template file:

```
mv $WORK_DIR/roles/wildflyapp/files/wildflyapp.service $WORK_DIR/roles/wildflyapp/templates/wildflyapp.template
```

Change the content of the service script file *$WORK_DIR/roles/wildflyapp/templates/wildflyapp.template* to have the following content:

```
[Unit]
Description=Wildfly Swarm Application Script
After=auditd.service systemd-user-sessions.service time-sync.target

[Service]
Environment="SECRET_NAME={{ secret_name }}"
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

As you can see the secret name is added to the template.

To run the playbook with your vault, you'll be required to give Ansible your password. Do so by creating a file named *.mypassword* and put the password in the file. Then run Ansible with the following command:

```
ansible-playbook -i hosts site.yml --vault-password-file .mypassword
```

You should now be able to access the url and observe your changes...

The observant student will note that there are some poor design choices in the above approach. Please correct the errors.

Hint:
* What did you learn about handlers in previous session?
* Does above solution use handlers appropriately?
* Is the when clause in above solution the best approach?

Consider how you would handle a test environment with the *SECRET_NAME* of 'Red Hat (test)'.

```
End of lab
```
[Go to the next lab, lab 6](../lab-6/README.md)
