# Writing the Wildfly playbook

Running wildfly swarm is a bit different than running traditional application servers. You package your application into a fat jar file, which you run from the command line. The jar file is very small (measured in MB) and only contains the libraries necessary to run your application.

For this excercise we assume that you've already packaged your application, using maven and pushed it to Nexus. From there you've pulled the file to the location *$WORK_DIR/labs/lab-3/lab-files/binaries/example-jaxrs-war-swarm.jar*

Explain roles

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
