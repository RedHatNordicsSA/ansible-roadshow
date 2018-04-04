# Introducing Ansible Tower
Red Hat Ansible Tower (build from the Open Source project, AWX) helps you scale out your Ansible automation
Running Ansible from a command line is all good, until you start to automate more things. When you do that, you get a number of concerns:

>How can I control who can run what playbooks where?

This is a central concerns which stimms from the fact that sharing access is difficult. 
Very often, you fail to automate things because it was not possible to share access. As an example, if you want to automate
the configuration of SAN storage at your company, your SAN storage switches may not allow granular enough access so that the users which you use to do the automation - can only do what you need it to do.
Because of this, it's not uncommon that attempts to automate things fails with conversations like:

>If I were to give you access to XYZ, you would be able to destroy all data at the company. And you don't even have XYZ training.

Ansible tower allows you to share access to other people via it's web GUI, a CLI client and a REST API. Let's explore how this works.

>First step, go unto your Ansible Tower server: https://<your-tower-server> and login with your assigned user.

Ansible tower

>How can I see who ran what playbook where?

>

Centralize and control your IT infrastructure with a visual dashboard, role-based access control, job scheduling, integrated notifications and graphical inventory management. 
And Ansible Tower's REST API and CLI make it easy to embed Ansible Tower into existing tools and processes.
