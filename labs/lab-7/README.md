# Introducing Ansible Tower

Red Hat Ansible Tower (build from the Open Source project, AWX) helps you scale out your Ansible automation. Running Ansible from a command-line interface is all good, until you start to automate more things. When you do that, you get a number of concerns, primarily:

>How can I control who can run what playbooks where?

This is a central concerns which stimms from the fact that sharing access is difficult. Because of this, some companies don't even allow people to share access, because of (valid) security concerns, security compliance requirements on separation of duty, and more.

Very often, you fail to automate things because it was not possible to share access. As an example, if you want to automate
the configuration of SAN storage at your company, your SAN storage switches may not allow granular enough access so that the users which you use to do the automation - can only do what you need it to do (which in that case would be to zone-in a disk to one or more specific servers).

Because of this, it's not uncommon that attempts to automate things fails with conversations like:

![Typical situation](../../content/images/you-cannot-have-access.png)

Ansible Tower allows you to share access safely to other people via it's web GUI, a CLI client and a REST API. Let's explore how this works.

1. First step, with your web browser, go to your Ansible Tower server: https://$Tower_Server and login with the _admin_ user and the password provided to you at the start of the lab.

What we'll do first is to create an inventory in Ansible Tower, an inventory is a collection of hosts you can run playbooks against in Tower; just like your *hosts* file in the previous examples. Inventories are assigned to organizations, while permissions to launch playbooks against inventories are controlled at the user, team or playbook level.

>Create an inventory called "workshop-inventory" by following the instructions below.

* To create a new inventory, click on the 'Inventories' tab and click the add button.

![Creating an inventory](../../content/images/create-new-inventory.png)

Insert values as in below screenshot.
![Inventory values](../../content/images/inventory-values.png)

Now we need to add our hosts to the newly created inventory.

Click "INVENTORIES" -> "workshop-inventory"

![Inventory add hosts](../../content/images/inventory-add-hosts.png)

From the inventory view, we click "Hosts" and then "Add host"
![Inventory add hosts](../../content/images/inventory-add-hosts-ii.png)

Fill in values as according to your **$WORK_DIR/hosts** file.
* Host names: _wildfly1, wildfly2 and loadbalancer1_
* Variables: _ansible_host: IP-address-of-system_

For instance in the following screenshot example values are provided for *client_system_1*. Refer to the previously created *hosts* file for IP values.
![Inventory add hosts](../../content/images/inventory-add-hosts-iii.png)

Next thing we'll do is to define a set of credentials to our systems. This is what is typically the tricky bit when you run Ansible playbooks from a command line. If you use a SSH key or username to an admin user to run your playbook, how can someone else run the playbook without you risking that person finding out the credentials - giving that person the ability to just SSH in manually to the system and run whatever he/she likes?

Credentials authenticate the Tower user to launch Ansible playbooks, which can then include passwords and SSH keys, against inventory hosts. You can also require the Tower user to enter a password or key phrase when a playbook launches using the credentials feature of Tower.

>Click on the gears in the top right corner, and select credentials
>Create a new set of credentials which you call 'machine-credentials' as follows.
* Credentials type: Machine
* Username: student
* Privilege Escalation Method: sudo
* SSH Private Key: the content of: https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa

 ![Creating a new set of credentials](../../content/images/credentials-create.png)

When you have saved your credentials, please note that the SSH Private key now reads "ENCRYPTED". This is because the key is now encrypted within Tower. It is not possible to get back the cleartext key, ergo, it's now safer to share this access with other people. Even the user (root) used, can also be obscured, only learning the name and description of the credentials visible.

Next thing that we'll do is to create a project. A Project is a logical collection of Ansible playbooks, represented in Tower.
You can manage playbooks and playbook directories by either placing them manually under the Project Base Path on your Tower server, or by placing your playbooks into a source code management (SCM) system supported by Tower, including Git, Subversion, and Mercurial.

>Create a project called "workshop-playbooks" by following the instructions below.

* To create a new project, click on the 'Projects' tab and click on the add button. Make sure to link your project to the GitHub repository, which [you created earlier in lab-6](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-6).

![Create a project](../../content/images/create-project.png)

Next you will provide access to the playbook which [you put onto GitHub earlier in lab-6](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-6). This is done using so called job templates. A job template combines an Ansible playbook from a project and the settings required to launch it.

>Create a job template called "workshop-template" which links to the playbook which you created earlier, as follows. Click "TEMPLATES" -> "ADD" -> "Job Template"
![Create a template](../../content/images/create-template.png)

Fill in values as in this screenshot
![Create a job template](../../content/images/create-template-ii.png)
and click 'SAVE'.

> Now try to run your playbook. (press the rocket, next to the name of the template). This should run the ping playbook successfully

If you now go to the 'Jobs' tab, you can review your specific run of the playbook, it lists information from the playbook run, who ran it and against what systems the playbook was run. This is all vital information as it allows visibility over what's being done in your infrastructure or application landscape.

Next we are going to provide this playbook, as a service to a new user, to see how we (safely) can provide any automation as a self service.

> Create a new users, by going to 'Settings (the cog)' and then users. Call the user workshop-guest and set a password for it. After saving the user go to it and configure it further:
* Click on the 'Permissions' tab and give your user access to run this one playbook. You do not have to provide access to either the project or the inventory, just the job template as a user, not an admin.

> Login as the user and run the playbook again. Review what you can see and what you can change as this user.

Next we are going to run this playbook via the Tower CLI. You can do it as your normal user or the guest user you created earlier.

> Login via SSH to the Tower server

> The Ansible Tower server has the tower-cli tool installed. Explore using
```
$ tower-cli --help
$ tower-cli job --help
```
and launch your playbook.

```
End of lab
```
[Go to the next lab, lab 8](../lab-8/README.md)
