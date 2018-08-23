# Introducing Ansible Tower
Red Hat Ansible Tower (build from the Open Source project, AWX) helps you scale out your Ansible automation. Running Ansible from a command line is all good, until you start to automate more things. When you do that, you get a number of concerns, primarily:

>How can I control who can run what playbooks where?

This is a central concerns which stimms from the fact that sharing access is difficult. Because of this, some companies don't even allow people to share access, because of (valid) security concerns, security compliance requirements on separation of duty, and more.

Very often, you fail to automate things because it was not possible to share access. As an example, if you want to automate
the configuration of SAN storage at your company, your SAN storage switches may not allow granular enough access so that the users which you use to do the automation - can only do what you need it to do (which in that case would be to zone-in a disk to one or more specific servers).

Because of this, it's not uncommon that attempts to automate things fails with conversations like:

>If I were to give you access to XYZ, you would be able to destroy all data at the company. And you don't even have XYZ training.

Ansible tower allows you to share access safely to other people via it's web GUI, a CLI client and a REST API. Let's explore how this works.

>First step, go unto your Ansible Tower server: https://<your-tower-server> and login with your assigned user.

What we'll do first is to create an inventory in Ansible Tower, an inventory is a collection of hosts you can run playbooks against in Tower. Inventories are assigned to organizations, while permissions to launch playbooks against inventories are controlled at the user, team or playbook level.

>Create an inventory called "yourUSERNAME-inventory" by following the instructions below.

* To create a new inventory, click on the 'Inventories' tab and click the add button.

 ![Creating an inventory](https://github.com/mglantz/ansible-roadshow/blob/master/content/create-new-inventory.png?raw=true)

Next thing we'll do is to define a set of credentials to our systems. This is what is typically the tricky bit when you run Ansible playbooks from a command line. If you use a SSH key or username to an admin user to run your playbook, how can someone else run the playbook without you risking that person finding out the credentials - giving that person the ability to just SSH in manually to the system and run whatever he/she likes?

Credentials authenticate the Tower user to launch Ansible playbooks, which can then include passwords and SSH keys, against inventory hosts. You can also require the Tower user to enter a password or key phrase when a playbook launches using the credentials feature of Tower.

>Create a new set of credentials which you call 'yourUSERNAME-credentials' as follows.
* Credentials type: Machine
* Username: root
* SSH Private Key: the content of: https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa

 ![Creating a new set of credentials](https://github.com/mglantz/ansible-roadshow/blob/master/content/credentials-create.png?raw=true)

When you have saved your credentials, please note that the SSH Private key now reads "ENCRYPED". This is because the key is now encrypted within Tower. It is not possible to get back the cleartext key, ergo, it's now safer to share this access with other people. Even the user (root) used, can also be obscured, only learning the name and description of the credentials visible.

Next thing that we'll do is to create a project. A Project is a logical collection of Ansible playbooks, represented in Tower.
You can manage playbooks and playbook directories by either placing them manually under the Project Base Path on your Tower server, or by placing your playbooks into a source code management (SCM) system supported by Tower, including Git, Subversion, and Mercurial.

>Create a project called "yourUSERNAME-playbooks" by following the instructions below.

* To create a new project, click on the 'Projects' tab and click on the add button. Make sure to link your project to the GitHub repository, which [you created earlier in lab-6](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-6).

 ![Create a project](https://github.com/mglantz/ansible-roadshow/blob/master/content/create-project.png?raw=true)

Next you will provide access to the playbook which [you put onto GitHub earlier in lab-6](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-6). This is done using so called job templates. A job template combines an Ansible playbook from a project and the settings required to launch it.

>Create a job template called "yourUSERNAME-playbobok" which links to the playbok which you created earlier, as follows:
* Associate the playbook to run on your assigned servers located in yourUSERNAME-inventory
* Associate the playbook with your project: yourUSERNAME-playbooks
* Select the playbook available in your GitHub repository
* Select the credentials you earlier created (yourUSERNAME-credentials) as 'machine credentials'.

 ![Create a job template](https://github.com/mglantz/ansible-roadshow/blob/master/content/job-template.png?raw=true)

> Now try to run your playbook.

If you now go to the 'Jobs' tab, you can review your specific run of the playbook, it lists information from the playbook run, who ran it and against what systems the playbook was run. This is all vital information as it allows visability over what's being done in your infrastructure or application landscape.

Next we are going to provide this playbook, as a service to a new user, to see how we (safely) can provide any automation as a self service.

> Create a new users, by going to 'Settings (the cog)' and then users. Call the user yourUSERNAME-guest and set a password for it. After saving the user go to it and configure it futher:
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
