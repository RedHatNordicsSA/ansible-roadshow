# ansible-roadshow
Hello and welcome. This is a hands on lab with Ansible and Ansible Tower.

## What is this?
This is a lab which provides an introduction to Ansible, Ansible Tower, how to write Ansible content and how to work with Ansible at scale. At the end of the day, you will know enough to go out in the real world and do real useful stuff.

```
Estimated time to complete this lab is 4-6 hours, depending on previous experience.
```

For an overview of the lab, go to: [Lab overview](#lab-overview)

## What is this NOT?
A complete walkthrough of all Ansible features and best practices. If you think something important is missing: contribute. For more information about contributing, see: [Contributing](#contributing). 

You may also want to have a look at https://github.com/ansible/lightbulb which is a more complete walkthrough of all things Ansible.

:exclamation: Some basic advise; This lab is not about doing it as fast as possible. It's about learning. Take your time to read the labs properly.

## Maintainers
This lab is maintained by members of Red Hat's Nordic Solution Architect team.
* Jacob Borella (![@jacobborella](https://github.com/jacobborella))
* Teemu Uotila (![@teemu-u](https://github.com/teemu-u))
* Ilkka Tengvall (![@ikke-t](https://github.com/ikke-t)
* Peter Gustafsson (![@pgustafs](https://github.com/pgustafs)
* Magnus Glantz (![@mglantz](https://github.com/mglantz)

## Contributing
This lab is an open source (GPL 3.0) project, so if you find any problems with it, feel free to open up an issue or send a pull request. For more information about contributing to this project, please see:

* [CODE OF CONDUCT](CODE_OF_CONDUCT.md)
* [CONTRIBUTING](CONTRIBUTING.md)
* [PROJECT LICENSE](LICENSE.md)

**_For information about installing this lab, go to the bottom of this page_.**

## Lab overview

The lab includes information about:

* Ansible basics (clientless nature, inventory, ansible-playbook basic commands)
* Git workflows for working with Ansible (GitHub workflow)
* How to create playbooks (basic playbooks, work with inventories and groups, encrypted vaults)
* How to work with roles (transform a playbook to a role)
* Ansible Tower (projects, inventories, job templates, credentials)
* An introduction to Ansible Galaxy
* How to create your own Ansible module
* How to work with Ansible code
* Ansible Tower basics
* How to test your Ansible playbooks and roles

**BELOW is an overview of the labs. This is for the students in the lab.**\
:exclamation: Start at 0 and go forward to 10. The labs depends on each other, so don't skip stuff.

0. [Getting started](labs/lab-0/README.md)

1. [Ansible basics](labs/lab-1/README.md)

2. [Writing Your First Playbook](labs/lab-2/README.md)

3. [Writing the Wildfly Playbook](labs/lab-3/README.md)

4. [Writing the Load Balancer Playbook](labs/lab-4/README.md)

5. [Handling Secrets with Ansible Vault](labs/lab-5/README.md)

6. [Working with Ansible as code](labs/lab-6/README.md)

7. [Introducing Ansible Tower](labs/lab-7/README.md)

8. [Installing wildfly and nginx from Tower](labs/lab-8/README.md)

9. [Testing Ansible playbooks](labs/lab-9/README.md)

10. [Developing Ansible Modules](labs/lab-10/README.md)

## Setting up the lab on AWS
This is for operators of the lab. Go to below page for information about setting up this lab on Amazon:
[Setting up the Ansible lab on AWS](content/README.md)
