# Installing the labs

These instructions guide you how to let Ansible provision the environment to Amazon AWS. All installation material is in ```content/``` -directory, instructions assume you are working in that directory. Start with cloning this repository, moving into working directory, and adding your ssh key to ssg-agent for ansible to use it:

```
git clone https://github.com/mglantz/ansible-roadshow.git
cd content
ssh-add
```

## Install Ansible

This setup was tested at the time of writing this README with Ansible version 2.6. Follow [Ansible install guidance](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for your favourite OS, Linux :) .

## Prepare the ansible dynamic inventory credentials

Before running the installer, you need to install Boto on your Ansible machine using [the Ansible AWS documentation](http://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html).

## Set AWS parameters for Ansible playbooks

Playbooks expect file ```content/vars.yml``` for setting your personal AWS credentials, machine AMI image and some other parameters. Copy ```content/vars-example.yml``` and fill it with your settings. You are recommended to use Ansible vault to encrypt your credentials.

## Encrypting credentials with Ansible Vault

Put whatever password into some file, in this example ```content/vault-password.txt```. Then you can use command ```ansible-vault --vault-password-file content/vault-password.txt encrypt_string``` to encrypt your credentials. The output can be used in the ```content/vars.yml``` file, see example.

You can also just put the credentials in plain text, but make sure you won't commit them into any git! Files ```content/vars.yml``` and ```content/vault-password.txt``` are ignored by git in this repo for safety.

## Install required roles

There is some dependencies for external roles in this setup. Use Ansible galaxy to install them:

```
ansible-galaxy install -p roles -r requirements.yml
```

## Run Ansible to provision the labs

There is playbook ```provision-all.yml``` which includes some other playbooks to create all necessary resources into AWS, and configure each of them. It will use dynamic inventory provided by ```content/ec2.py```. That's why you need boto setup in addition to credentials in ```content/vars.yml```.

```
ansible-playbook --vault-password-file vault-password.txt -i ec2.py do_all.yml
```

_if you don't use vault, ignore ```vault-password-file``` parameter_

## Delete all resources after doing labs

__Beware this might leave something out, do check yourself from AWS__

There is a helper playbook, which deletes all resources created for this lab from AWS. But you never know if someone adds something to labs, and forgets to also add it into ```delete_instances.yml``` playbook. If you develope this further, do always remember to include your added resources into ```delete_instances.yml```.

After labs are done, stop billing by running:

```
ansible-playbook --vault-password-file vault-password.txt -i ec2.py delete_instances.yml
```

_if you don't use vault, ignore ```vault-password-file``` parameter_

# HAPPY LABS!

Systems should be up in 15 minutes. Happy learning!

# ToD0

At the time of writing, not all playbooks are included in do_all.yml. Remove this line once the issue is taken care of.
