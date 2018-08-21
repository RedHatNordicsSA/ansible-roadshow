# Developing Ansible Modules
This chapter will go through what a module is, what you need to consider before writing a module and how to write some different types of Ansible modules. Don't worry, it's not that complicated.

# About Ansible modules and what to consider before writing one
To reiterate, modules are Ansible's tools in a toolbox. Ansible playbooks calls upon modules to get work done, as can be seen below.

 ![Playbooks calls upon modules](https://github.com/mglantz/ansible-roadshow/blob/master/content/modules.png?raw=true)

## Should you develop a module?
The first thing you should ask yourself when developing an Ansible module is, should you develop a module? Before you get started on development, walk through this little checklist.

* Does a similar module exist?
See: http://docs.ansible.com/ansible/latest/modules/modules_by_category.html
* Is there development already ongoing for a similar module?
See: https://github.com/ansible/ansible/labels/new_module
See: https://github.com/ansible/ansible/labels/module
See: https://ansible.sivel.net/pr/byfile.html
* Should you use or develop an action plugin instead?
* Should you use a role instead? (14 000 exists on Galaxy)
* Should you write one or multiple modules? (Remember that complexity kills productivity)

## Different types of Ansible modules
If you've decided to develop a module, let's review the different types of modules that exists.

* Action plugins - always execute server-side and are sometimes able to do all work there (example: debug, template)
* New-style modules - all that ship with Ansible. Arguments embedded in module instead of separate file, reducing the need for a transfer of a separate file containing arguments.
* Python - New-style Python modules use the Ansiballz framework for constructing modules. These modules use imports from ansible.module_utils in order to pull in boilerplate module code, such as argument parsing, formatting of return values as JSON and various file operations.
* Powershell - for Windows systems, they use the Module Replacer framework for constructing modules.
* JSONARGS - Scripts that arrange for an argument string to be placed within them using special string:
```
jsonargs = “<<INCLUDE_ANSIBLE_MODULE_JSON_ARGS>>”
```
* Non-native WANT_JSON modules - If a module has the string WANT_JSON in it anywhere, Ansible treats it as a non-native module that accepts a filename as its only command line parameter, the format of the argument file will then be in JSON. Otherwise it will be key=value.
* Binary module - compiled small program, works like a WANT_JSON module.
* And more http://docs.ansible.com/ansible/latest/dev_guide/developing_program_flow_modules.html

## Modules written in other languages than Python and Powershell
Modules can be written in any language an author wishes, they just need to specify certain special strings in their code.  If not, a file containing the module args will be uploaded, and the path to that file is the first argument to the module. If your module contains the string WANT_JSON, that args file will be formatted as JSON (otherwise they’re key=value pairs). _As of Ansible version 2.0, modules must output JSON (key=value output is no longer allowed)._

## Module execution workflow
1. task_executor - TaskExecutor decides if it’s an action plugin or a module. If module, it loads ‘Normal Action Plugin’ and passes info about what’s to be done.
2. Normal Action Plugin - Inits connection. Pushes module to host. Executes the module on the remote host.  Primary coordinator.
3. module_common.py - Identifies module type, selects preprocessor.
4. Module Replacer/Ansiballz - Preprocessors which does substitutions of specific substring patterns in the module file. Read more here: https://docs.ansible.com/ansible/latest/dev_guide/developing_program_flow_modules.html#module-replacer
5. Passing arguments - module arguments are turned into a JSON-ified string and passed to the module.
6. Internal arguments - parameters which implements global features. Often you do not need to know about these.

# Writing your first Ansible modules
You're now stuffed with some good to know information and is ready to write your first Ansible modules. At the end of this chapter you will have written two simple Ansible modules which you can extend with arbitrary functionality to fit your real world use case.

## Module writing strategies
There are three different strategies when writing Ansible modules, each one with some different pros and cons.

* Wrap a CLI command
_PROs:_
```
Easy to write, low learning curve.
Protects users from complexity
```
_CONs:_
```
Output/results have to be scraped out of the CLI output, which is very fragile and prone to error, eg:
cli_command|awk ‘{ print $6 ‘}|cut -d’/’ -f2|sed ‘s/old/new/'
Depending on use-case - only slightly more useful than using command/shell modules.
```

* Using 3rd Party Libraries
_PROs_:
```
Also very easy to get started with, since someone else has done the hard work for you.
```

_CONs:_
```
Extra dependencies for users running your module remotely (the library must be installed everywhere you run the module).
Modules may not cover API features you need (especially new features).
Bugs and abandonment (don’t forget to evaluate).
```

* Interacting With the API Directly
_PROs_:
```
No extra dependencies (Ansible provides helper code in module_utils/urls.py to make HTTP calls).
New features are accessible immediately without having to wait.
```

_CONs:_
```
Having to know the API and extra maintenance work for the module.
```

## Develop a module (Wrap CLI, non-native)
Our first module will simply wrap a CLI command (_touch_). It will be non-native, meaning that it will receive it's arguments in a separate arguments file as the first argument passed to the module. The arguments file will be using a key=value format.

First, let's create a directory in which we'll develop the module.
```
cd ansible-roadshow/lab-10
mkdir new-module
cd new-module
```

Secondly, let's create a simple module using Bourne Again SHell (BASH) script.
```
vi new-module
```

We start with the most simple version of this module, as following:
```
#!/bin/sh
# Module which creates the file: /tmp/module-file
set -e
# First argument is the arguments file
source ${1}
# Create file
touch /tmp/module-file
# Output JSON
echo {\"changed\": true, \"msg\": \"${msg}\"}
exit 0
```

Next, copy the module into the module directory.
```
cp new_module /usr/share/ansible/plugins/modules/
```

Now we'll create a playbook to test our module. Create a file called test.yml in your local directory, as follows:
```
- hosts: localhost
  gather_facts: no
  tasks:
    - new_module:
       msg: "hello world"
```

Now let's test our module.
```
ansible-playbook -vv ./test.yml
```

Expected output should be something like:
```
Using /etc/ansible/ansible.cfg as config file
1 plays in test.yml

PLAY ***************************************************************************

TASK [new_module] ***************************************************************
changed: [localhost] => {"changed": true, "msg": "hello world"}

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0   
```

Now that we have a working module, let's improve it a bit, handling the case if something goes wrong. Change the module so that it handles the case if it's possible to create a file containing the input passed to it. Create some exception handling in the module and output:
```
echo {\"failed\": true, \"msg\": \"${msg}\"}
```
If you detect a failure. If you get stuck, have a look at a solution here:
http://github.com/mglantz/ansible-roadshow/labs/lab-10/lab-solutions/module-v2.sh

Re-run your test.yml playbook to ensure your modifications work, then you can try and replace _/tmp/module-arguments_ in the module to _/tmp/doesnotexist/module-arguments_ to cause it to fail. Then change it back to _/tmp/module-arguments_

Next step is to create a simple check if the _/tmp/module-arguments_ file already exists and then return JSON output with _changed: false_.

If you get stuck, have a look at a solution here:
http://github.com/mglantz/ansible-roadshow/labs/lab-10/lab-solutions/module-v3.sh

OLD:
First of all read the [Ansible Developing Modules](http://docs.ansible.com/ansible/latest/dev_guide/developing_modules.html) page. Especially the 'Should You Develop A Module?' section is relevant:-)

Next follow the steps in https://docs.ansible.com/ansible/2.5/dev_guide/developing_modules_general.html, but skip the section 'Prerequisites Via Apt (Ubuntu)'. This has been done for you. Be aware that we use python2, so ignore python3 stuff.

For debugging in python refer to [Python documentation for debugger](https://docs.python.org/2/library/pdb.html)
