# Preparations

In this lab, you'll work with a pretty simple, yet usable server setup.

![Image of server setup](demo-env.png)

The Tower server will have the responsibility of provisioning the servers, which are implementing a simple http based service.

The NGINX server is responsible for balancing the load between the two backend servers. The backends are implemented using wildfly swarm, run as a simple java application.

In order to prepare for the labs, open a command promt.

Clone the lab files to your drive:
1. Navigate to a location of your choice.
2. Use the command *git clone https://github.com/mglantz/ansible-roadshow.git* to pull the code to your computer.
3. $LAB_DIR will refer to the root of the cloned repository*.

Create an empty dir, where you will do your assignments. This dir will be refered to as $WORK_DIR
