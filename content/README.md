# installing the labs

Before running the installer, you need to install Boto on your Ansible machine using [the Ansible AWS documentation](http://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html). Then you need to put your ec2 access key in and ec2 secret key in provision.yml.

Finally run
```
ansible-playbook provision.yml
```

