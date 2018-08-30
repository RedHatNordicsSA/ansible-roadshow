# Writing your first playbook

In the previous lab, you called a module directly from the command-line interface. A module is a piece of code, which encapsulates some functionality. The ping module, which we used in lab 1, is part of the module library of Ansible. The module library is included with the Ansible installation, and can be used without installing any extra stuff. For a complete overview of modules, refer to [the module index](http://docs.ansible.com/ansible/latest/modules_by_category.html).

In almost all cases, you will use a playbook for automating the management of your servers. Think of a playbook as a recipe for the state of your servers as well as other infrastructure components. In a playbook you can describe everything from software which needs to be installed on servers to how load balancers should be configured. And everything which is done, is done by a module which is called, as shown below.

![Overview of Ansible architecture](../../content/images/playbook-overview.png)

A playbook can also describe sequences of actions and other process related concerns. The Ansible runtime is the (_state_) engine, which interprets and applies the playbooks to the servers.

Let's try to implement the ping example using a playbook. But before we start, let's details some basic best practices when writing playbooks. First, there are several ways you can write a playbook. Looking at the internet, you'll find them all. What we recommend is to use the native YAML syntax. The reason for that is that reading vertically is _easier_ than reading horizontally. Observe below two example where both are valid Ansible, which one do you prefer reading? Which one is easier to scan for a specific value?

* Valid syntax
```
- name: install telegraf
  yum: name=telegraf-{{ telegraf_version }} state=present update_cache=yes disable_gpg_check=yes enablerepo=telegraf
  notify: restart telegraf
```
* Native YAML syntax
```
- name: install telegraf
  yum:
    name: telegraf-{{ telegraf_version }}
    state: present
    update_cache: yes
    disable_gpg_check: yes
    enablerepo: telegraf
  notify: restart telegraf
```

Now, we're ready to create our first playbook. Create a playbook: $WORK_DIR/ping.yml, by pasting below into your terminal: 

```
cat << 'EOF' >$WORK_DIR/ping.yml
---
- hosts: all
  tasks:
  - name: Call the ping module
    ping:
      data: pong from Ansible
EOF
```

This will do the same as the previous lab, except the ping message is different. The ping message takes an argument *data*, which is the reply message from the ping module. You can now run the playbook with the command

```
ansible-playbook -i hosts ping.yml
```

Wouldn't it be nice if you could actually see the reply from the ping module? This can be done by using return values combined with the *msg* module. Change the *$WORK_DIR/ping.yml* file to the following

```
---
- hosts: all
  tasks:
  - name: Call the ping module
    ping:
      data: pong from Ansible
    register: ping_answer
  - name: Output the value of the ping answer
    debug:
      msg: "Return value from ping is '{{ping_answer.ping}}'"
```

```
ansible-playbook -i hosts ping.yml
```

This will result in the following output:

```
$ ansible-playbook -i hosts ping.yml

PLAY [all] *************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [wildfly1]
ok: [wildfly2]
ok: [loadbalancer1]

TASK [Call the ping module] ********************************************************************************************
ok: [wildfly2]
ok: [loadbalancer1]
ok: [wildfly1]

TASK [Output the value of the ping answer] *****************************************************************************
ok: [loadbalancer1] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}
ok: [wildfly1] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}
ok: [wildfly2] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}

PLAY RECAP *************************************************************************************************************
loadbalancer1              : ok=3    changed=0    unreachable=0    failed=0   
wildfly1                   : ok=3    changed=0    unreachable=0    failed=0   
wildfly2                   : ok=3    changed=0    unreachable=0    failed=0   
```

Now you can see the output from the ping module. Nice! Return values are useful for a lot of things.

Another useful feature of Ansible is the PLAY RECAP. Here you can see how running the playbooks went. For now just notice that no state has changed (changed=0 for each server). This is because the ping message never changes state of the server and thus is idempotent. Idempotency is an important concept in Ansible. Idempotency means that the module called will have the same effect on the server, no matter how many times you run it on the server (more about that later).

Try changing the ping message to 'crash'. What happens? HINT:
1. Look in the [source code for the ping module](https://github.com/ansible/ansible-modules-core/blob/devel/system/ping.py)
2. Do appropriate change in ping.yml and run the playbook again.

```
End of lab
```
[Go to the next lab, lab 3](../lab-3/README.md)
