# Testing Ansible playbooks
In order to handle Ansible as code you need to do testing. Without testing, there is no way that you can keep your main git branch releasable.
It's neither possible for you to keep up the quality of your code or to scale out the usage of Ansible, as without proper testing, less people can contribute.

Take the time to apply this basic 6 step framework for testing your Ansible.

A basic framework for Ansible testing is:
* Verify correct syntax with
```
ansible-playbook --syntax-check your-playbook.yml
```

* Verify style for bad practices and behaviour that could potentially be improved.
```
ansible-lint your-playbook.yml
```

* Run your playbook or role and ensure it completes without failures. Create a script, such as:
```
ansible-playbook your-playbook.yml >test.output 2>&1 || true
if grep -q 'unreachable=0.*failed=0' test.output; then
  echo "Playbook executed without issues."
else
  echo "Issues executing playbook."
  cat test.out
  exit 1
fi
```

* Run your playbook or role again and ensure that no changes are reported, this ensures playbook idempotency a key feature of Ansible. Create a script, such as:
```
if grep -q 'changed=0.*unreachable=0.*failed=0' test.output; then
  echo "Idempotence test OK"
else
  echo "Idempotence test failed. Details below:"
  cat test.out
  exit 1
fi
```

* Query your application's API or do another external test of it's functionality.
```
curl -s http://your-app
```

* And last but not least, integrate the testing into your development pipeline. Ensure that when your code merges, it's always tested.
If you are interested in how this can be done using Jenkins and Ansible tower, have a look here:
https://github.com/mglantz/tomcat-playbook/

* As a list exercise, create a single script which does testing of arbitrary playbooks. Use any language you like.

```
End of lab
```
[Go to the final lab, lab 10](../lab-10/README.md)
