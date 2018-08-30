# Writing your first playbook

In the previous lab, you called a module directly from the command-line interface. A module is a piece of code, which encapsulates some functionality. The ping module, which we used in lab 1, is part of the module library of Ansible. The module library is included with the Ansible installation, and can be used without installing any extra stuff. For a complete overview of modules, refer to [the module index](http://docs.ansible.com/ansible/latest/modules_by_category.html).

In almost all cases, you will use a playbook for automating the management of your servers. Think of a playbook as a recipe for the state of your servers as well as other infrastructure components. In a playbook you can describe everything from software which needs to be installed on servers to how load balancers should be configured. A playbook can also describe sequences of actions and other process related concerns.
The Ansible runtime is the engine, which interprets and applies the playbooks to the servers.

Let's try to implement the ping example using a playbook. Open a new file for editing called *$WORK_DIR/ping.yml* and paste the following content into the file

```
---
- hosts: all
  tasks:
  - name: Call the ping module
    ping:
      data: pong from Ansible
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

this will result in the following output

```
[root@ip-172-31-18-241 playbooks]# ansible-playbook -i hosts -u root ping.yml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [54.93.67.223]
ok: [35.159.18.245]
ok: [54.93.150.126]

TASK [Call the ping module] ****************************************************
ok: [54.93.67.223]
ok: [54.93.150.126]
ok: [35.159.18.245]

TASK [Output the value of the ping answer] *************************************
ok: [54.93.67.223] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}
ok: [54.93.150.126] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}
ok: [35.159.18.245] => {
    "msg": "Return value from ping is 'pong from Ansible'"
}

PLAY RECAP *********************************************************************
35.159.18.245              : ok=3    changed=0    unreachable=0    failed=0   
54.93.150.126              : ok=3    changed=0    unreachable=0    failed=0   
54.93.67.223               : ok=3    changed=0    unreachable=0    failed=0   
```

Now you can see the output from the ping module. Nice right! Return values are useful for a lot of things.

Another useful feature of Ansible is the PLAY RECAP. Here you can see how running the playbooks went. For now just notice that no state has changed (changed=0 for each server). This is because the ping message never changes state of the server and thus is idempotent. Idempotency is an important concept in Ansible. Idempotency means that the module called will have the same effect on the server, no matter how many times you run it on the server (more about that later).

Try changing the ping message to 'crash'. What happens? HINT:
1. Look in the [source code for the ping module](https://github.com/ansible/ansible-modules-core/blob/devel/system/ping.py)
2. Do appropriate change in ping.yml and run the playbook again.

```
End of lab
```
[Go to the next lab, lab 3](../lab-3/README.md)
