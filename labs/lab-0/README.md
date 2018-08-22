# Preparations

1. To get started with the labs, you first needs to get your assigned username and servers. This will be provided to you live by the people who operates this lab.

2. Please review the overview of the lab environment. Most importantly, the Ansible control servers is from where all the labs are done.
```
PLEASE NOTE
DO NOT execute the labs from your local laptop.
```

![Overview of lab environment](demo-env.png)

* _Please note that the Ansible control server is from where all labs are executed._

The Tower server will have the responsibility of provisioning the servers, which are implementing a simple http based service.

The NGINX server is responsible for balancing the load between the two backend servers. The backends are implemented using wildfly swarm, run as a simple java application.

1. In order to prepare for the labs, open a command

Clone the lab files to your drive:
1. Navigate to a location of your choice.
2. Use the command *git clone https://github.com/mglantz/ansible-roadshow.git* to pull the code to your computer.
3. $LAB_DIR will refer to the root of the cloned repository*.

Create an empty dir, where you will do your assignments. This dir will be refered to as $WORK_DIR, suggestion is that you export $WORK_DIR as a variable in your shell. So, for example:
```
$ mkdir /home/student/work
$ WORK_DIR=/home/student/work
```
