#  :thumbsup: Testing Ansible playbooks

In order to handle Ansible as code you need to do testing. Without testing, there is no way that you can keep your main git branch releasable.
It's neither possible for you to keep up the quality of your code or to scale out the usage of Ansible, as without proper testing, fewer people can contribute.

Take the time to apply this basic 5 step framework for testing your Ansible.

A basic framework for Ansible testing is:

```
START OF TEST FRAMEWORK
```

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
* Run the playbook manually and check for any failures (add --check for dry-run):
```
cd $WORK_DIR
ansible-playbook --check -i hosts problem.yml
```

* Or better, create a script which does this, by pasting below into a terminal:
```
cat << 'EOF' >$WORK_DIR/playbook-test.sh
ansible-playbook -i $WORK_DIR/hosts $1 >test.output 2>&1 --vault-password-file mypassword || true
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
ansible-playbook -i $WORK_DIR/hosts $1 >test.output 2>&1 --vault-password-file mypassword || true
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
curl http://wildfly1
```

```
END OF TEST FRAMEWORK
```

:boom: Let's apply the above test framework on below playbook. Create a new playbook $WORK_DIR/problem.yml by copying below code into your terminal:
```
cd $WORK_DIR
cat << 'EOF' >problem.yml
- name: Create directory and restart NGINX
  hosts: lbservers
  tasks: 
    - name: Create directory
      command: mkdir /tmp/logs

    - name: Restart NGINX
       shell: systemctl restart nginx
EOF
```

:boom: Use the testing framework your learned and fix all issues in the above playbook. The playbook should pass all steps of this test framework to be deemed OK for production. Output such as below, can be ignored.
```
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'
```
 :exclamation: Have a look at other available modules, listed here: https://docs.ansible.com/ansible/latest/modules/modules_by_category.html and how to use them in a playbook.

 :exclamation: If you get stuck or want to compare with your _fixed_ playbook, have a look here at a problem free version of the playbook:
https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/labs/lab-9/lab-files/problem-free.yml

:star: As an optional exercise, if you have time, create a single script which implements the testing framework and which can be run on arbitrary playbooks. Use any language you like.

:star: The testing practice is to integrate testing into your development pipeline for Ansible playbooks. Ensure that when your code merges, it's always tested. If you are interested in how this can be done using Jenkins and Ansible Tower, have a look here:
https://github.com/mglantz/tomcat-playbook/

# :star: More to read

[Molecule](https://molecule.readthedocs.io/en/latest/) is a project designed to aid in the development and testing of Ansible roles.
It's opinitated and help enforcing best practices by verifying syntax, style, idempotence... It can even run tests after your playbook was run
with a framework like [Testinfra](https://testinfra.readthedocs.io/en/latest/).

Check the documentation for more information: https://molecule.readthedocs.io/en/latest/

```
End of lab
```
[Go to the final lab, lab 10](../lab-10/README.md)
