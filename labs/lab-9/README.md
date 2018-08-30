# Testing Ansible playbooks

In order to handle Ansible as code you need to do testing. Without testing, there is no way that you can keep your main git branch releasable.
It's neither possible for you to keep up the quality of your code or to scale out the usage of Ansible, as without proper testing, less people can contribute.

Take the time to apply this basic 6 step framework for testing your Ansible.

A basic framework for Ansible testing is:

1. Verify syntax
```
You can verify your Ansible syntax using: 
ansible-playbook --syntax-check playbook.yml
```

2. Verify style
```
You can verify the style of your playbook using:
ansible-lint playbook.yml
```

3. Run the playbook and check for issues:
* Run the playbook manually and check for any failures:
```
cd $WORK_DIR
ansible-playbook -i hosts problem.yml
```

* Or better, create a script which does this, by pasting below into a terminal:
```
cat << 'EOF' >$WORK_DIR/playbook-test.sh
ansible-playbook -i $WORK_DIR/hosts $1 >test.output 2>&1 || true
if grep -q 'unreachable=0.*failed=0' test.output; then
  echo "Playbook $1 executed without issues."
else
  echo "Playbook $1 failed to run:"
  cat test.output
  exit 1
fi
EOF
chmod a+rx $WORK_DIR/playbook-test.sh
```
>Run the script like such:
```
cd $WORK_DIR
./playbook-test.sh playbook.yml
```

4. Run the playbook one more time and check for idempotency. The ability to re-run a playbook without issues is key to writing useful playbooks.
* Run the playbook manually and make sure _changed_ equals 0 in the output: 
```
cd $WORK_DIR
ansible-playbook -i hosts problem.yml
```

* Or better, create a script which does this, by pasting below into a terminal:
```
cat << 'EOF' >$WORK_DIR/idempotency-test.sh
ansible-playbook -i $WORK_DIR/hosts $1 >test.output 2>&1 || true
if grep -q 'changed=0.*unreachable=0.*failed=0' test.output; then
  echo "Playbook $1 is idempotent."
else
  echo "Playbook $1 failed idempotency test:"
  cat test.output
  exit 1
fi
EOF
chmod a+rx $WORK_DIR/idempotency-test.sh
```
>Run the script like such:
```
cd $WORK_DIR
./idempotency-test.sh playbook.yml
```

5. Check result of change (Check webpage of http server, etc)
```
curl http://client_system_1
```

```
Lab exercises below
```

1. Let's apply this framework on below playbook. Create a new playbook $WORK_DIR/problem.yml by copying below code into your terminal:
```
cat << 'EOF' >problem.yml
- name: Create directory and restart tomcat
  hosts: wildflyservers
  tasks:
    - name: Create directory
      command: mkdir /tmp/logs

    - name: Restart Tomcat
       shell: systemctl restart tomcat
EOF
```

2. Use the above testing framework and fix all issues in the above playbook:
Output such as below, can be ignored.
```
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'
```
If you get stuck or want to compare with your _fixed_ playbook, have a look here at a problem free playbook:
<insert link>

3. As an optional exercise, create a single script which implements the testing framework and which can be run on arbitrary playbooks. Use any language you like.

> More reading
You should integrate the testing into your development pipeline. Ensure that when your code merges, it's always tested.
If you are interested in how this can be done using Jenkins and Ansible Tower, have a look here:
https://github.com/mglantz/tomcat-playbook/

```
End of lab
```
[Go to the final lab, lab 10](../lab-10/README.md)
