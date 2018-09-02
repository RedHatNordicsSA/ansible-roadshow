# Installing the labs

These instructions guide you how to let Ansible provision the environment to Amazon AWS. All installation material is in ```content/``` -directory, instructions assume you are working in that directory. Start with cloning this repository, moving into working directory, and adding your ssh key to ssh-agent for Ansible to use it:

```
git clone https://github.com/mglantz/ansible-roadshow.git
cd content
ssh-add /path/to/your/amazon-ssh-key-file.pem
```

# Pre-requisites

## Install Ansible

This setup was tested at the time of writing this README with Ansible version 2.6.
To install Ansible follow [Ansible install guidance](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for your favourite OS, Linux :) .

## Ansible dynamic inventory

Before running the installer, you need to install boto Python modules on your Ansible machine using [the Ansible AWS documentation](http://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html).

## Known issues
* When running the installer, a task regarding the GitLab server may fail as shown below, just wait a minute and then re-run the playbook if that is the case.

```
PLAY [setup stuff in Gitlab VMs] ***************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
The authenticity of host '18.184.66.48 (18.184.66.48)' can't be established.
ECDSA key fingerprint is SHA256:xdDsD7vJe9GFVbxhXe7/xgwpkyQecmL1NJ0F7bR8Zmo.
Are you sure you want to continue connecting (yes/no)? yes
fatal: [18.184.66.48]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '18.184.66.48' (ECDSA) to the list of known hosts.\r\nConnection reset by 18.184.66.48 port 22\r\n", "unreachable": true}
	to retry, use: --limit @/path/to/ansible-roadshow/content/provision-all.retry
```

* When doing repeated setups of brand new environments, gitlab server install fails due to gitlab_server.out contains old values. Solve problem by removing old entries.

Playbook fails as such:
```
TASK [Create project] **************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Invalid header value 'ec2-52-57-173-62.eu-central-1.compute.amazonaws.com\\nhttps:'"}
	to retry, use: --limit @/path/to/ansible-roadshow/content/gitlab-setup.retry

PLAY RECAP *************************************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=1   

```

## Set parameters to Ansible variables file

Playbooks expect file ```content/vars/vars.yml``` to contain settings your personal AWS credentials, machine AMI image and some other parameters. Copy ```content/vars/vars-example.yml``` and fill it with your settings. It is recommended to use Ansible Vault to encrypt your credentials.

## Encrypting credentials with Ansible Vault

Put password of your choice into a text file. In this example ```content/vault-password.txt```. Then you can use command ```ansible-vault --vault-password-file content/vault-password.txt encrypt_string``` to encrypt your credentials. The output can be used in the ```content/vars/vars.yml``` file, see example in ```content/vars/vars-example.yml -file.

You can also put the credentials in plain text, but you should make sure that you don't commit them into any git repository! Files ```content/vars/vars.yml``` and ```content/vault-password.txt``` are ignored by git in this repository for your safety.

## Install required roles

There are some dependencies for external roles in this setup. You can use Ansible Galaxy to install them:

```
ansible-galaxy install -p roles -r roles/requirements.yml
```

# Provision the lab environment

## Ansible run

Playbook ```provision-all.yml``` includes other playbooks to create all necessary resources into AWS, and configure each of them. It will use dynamic inventory provided by ```content/inventory/ec2.py```. That's why you need boto Python modules installed in addition to AWS credentials in ```content/vars/vars.yml```.

```
ansible-playbook --vault-password-file vault-password.txt -i inventory/ec2.py provision-all.yml
```

:boom: _If you don't use Ansible Vault, ignore ```vault-password-file``` parameter_

# Create Gitlab access token

Once the environment has been provisioned and if you don't feel like using GitHub, you can use Gitlab that was installed with the lab environment.
__Due to limitations in the Gitlab API, you have to create access key for the root user, that was created during the installation by hand.__ This has to be done in order to get the ansible-roadshow -project and student users set up to Gitlab.

Gitlab's default administrator account details are below; be sure to login immediately after installation and change these credentials!

    root
    5iveL!fe

Gitlab will automatically prompt you to change the password.
Password should be set to ```redhat123```, or if you end up choosing something different you will have to modify gitlab-setup.yml to comply with your password.

Once you are logged in, it's time to create the access token for the Administrator user(root).

From the top-right corner click on the avatar and choose settings:

![gitlab settings](images/gitlab-settings-menu.png)

At the settings -page go to menu called "Access Tokens" that is at the left side of the screen:

![gitlab token](images/gitlab-token-menu.png)

From that menu you can create Access Token(s) to access the API.
You can name the Access Token how ever you like, but make sure to tick all the boxes under the Scope -section:

![gitlab token creation](images/gitlab-create-token.png)

Once you click on the "Create personal access token" -button, Access Token will be generated for you, be sure to copy it to your clipboard:

![gitlab token created](images/gitlab-token-created.png)

Once you have the access token on your clipboard, copy it to gitlab_token -variable in vars.yml -file and run the gitlab-setup.yml -playbook:

    ansible-playbook gitlab-setup.yml

This will copy the content of the workshop from GitHub to your Gitlab server and create as many user accounts as you have Ansible tower systems.
Users will be named ```student1``` to ```studentX``` and password for the student accounts will be ```redhat123```.

## Installation of Ansible Tower
The installation of Ansible Tower is completely automatic. If you need to know how the automatic installation happens, read up on: https://github.com/mglantz/ansible-roadshow/blob/master/content/scripts/tower-prep.sh

The tower-prep.sh script dumps an inventory (tower-inventory) and a playbook (tower-install.yml) /root. The tower-install.yml playbook is what installs Tower. 

The reason for this is because fetching the script from GitHub is unreliable when doing large lab environments. Also, it hard codes against this repository, which makes testing branches a nightmare.

After tower-prep.sh has dropped the playbook and the inventory, the installation is then run at the end of tower-prep.sh like so:
```
ansible-playbook -i /root/tower-inventory /root/tower-install.yml
```

## Turning off all access to the environment
Because of security reasons when provisoning the environment in advance, or to ensure that all students starts the labs at the same time, you may want to turn off all access to the environment after having provisioned it.
Deny all incoming traffic to the environment by running below playbook:
```
ansible-playbook -i inventory/ec2.py turn_off_access.yml
```

## Turning on all access to the environment
If you have turned off all access to the environment by running the _turn_off_access.yml_ playbook, turn access back to normal by running:
```
ansible-playbook -i inventory/ec2.py turn_on_access.yml
```

## Delete all resources after doing labs

__Beware this might leave something out, do check yourself from your AWS account__

There is a helper playbook, which deletes all resources created for this lab from AWS. But you never know if someone adds something to labs, and forgets to also add it into ```delete_instances.yml``` playbook. If you develop this further, do always remember to include your added resources into ```delete_instances.yml```.

After labs are done, stop billing by running:

```
ansible-playbook --vault-password-file vault-password.txt -i inventory/ec2.py delete_instances.yml
```

_if you don't use vault, ignore ```vault-password-file``` parameter_

# HAPPY LABS!

Systems should be up in 10 minutes. Ansible Tower servers will be up in aproximately 30 minutes. Happy learning!

# ToD0

At the time of writing, not all playbooks are included in do_all.yml. Remove this line once the issue is taken care of.
