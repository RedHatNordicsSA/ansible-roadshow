# Writing your first playbook

In the previous lab, you called a module directly from the command line. A module is a piece of code, which encapsulates some functionality. In this case, the module enables you to:
1. SSH to a server
2. On the server run the ping.py script, which
3. Copies the input variable *data* to result *ping* 

```
---
- hosts: all
  tasks:
  - name: Call the ping module
    ping:
      data: Ansible!
```

This will do the same as previous lab, except the ping message is different

add

```
---
- hosts: all
  tasks:
  - name: Call the ping module
    ping:
      data: Ansible!
    register: ping_answer
  - name: Output the value of the ping answer
    debug:
      msg: "Return value from ping is '{{ping_answer.ping}}'"
```

output

```
[root@ip-172-31-18-241 playbooks]# ansible-playbook main.yaml 

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
    "msg": "Return value from ping is 'Ansible!'"
}
ok: [54.93.150.126] => {
    "msg": "Return value from ping is 'Ansible!'"
}
ok: [35.159.18.245] => {
    "msg": "Return value from ping is 'Ansible!'"
}

PLAY RECAP *********************************************************************
35.159.18.245              : ok=3    changed=0    unreachable=0    failed=0   
54.93.150.126              : ok=3    changed=0    unreachable=0    failed=0   
54.93.67.223               : ok=3    changed=0    unreachable=0    failed=0   
```


