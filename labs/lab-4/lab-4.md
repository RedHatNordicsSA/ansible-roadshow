# Writing the load balancer playbook

In the previous lab, we created two wildfly swarm servers running our application. The next step is to setup a loadbalancer. We will use nginx as the loadbalancer in this lab.

A role has already been written for installing nginx with Ansible. The role can be found at the Ansible Galaxy site (https://galaxy.ansible.com/nginxinc/nginx/). [Ansible Galaxy](https://galaxy.ansible.com) is the place where roles and modules are shared. As always be critical when using content on the internet. In this case the nginx organisation has made an official role for nginx, so we should be good.

First we need to install the role for nginx. Run:

```
$ansible-galaxy install nginxinc.nginx
```

and wait for the role to be installed. When that is done, we can use the role in our playbooks.

To install nginx go to $WORK_DIR and create a new file named *lb.yml* with the following content:

```
---
- hosts: lbservers
  user: "{{host_user}}"
  become: true
  tasks:
  - include_role:
      name: nginxinc.nginx
```

run the playbook with the command

```
$ansible-playbook --extra-vars "host_user=$MY_HOST_USER" lb.yml
```

this will install nginx on the servers in the lbservers group. To verify the installation, go to the url *http://$lb_server_name*. You should get the nginx default page.

Next step is to configure nginx as a loadbalancer for the two wildflyapp servers. To do so, we need some additional steps in our playbook. Change lb.yml to have the following content:

```
---
- hosts: lbservers
  user: "{{host_user}}"
  become: true
  vars:
    wildfly_servers: "{{ groups['wildflyservers'] }}"
  tasks:
  - include_role:
      name: nginxinc.nginx
  - name: Setup the http listener to your machines
    template:
      src: roles/nginx/files/default.template
      dest: /etc/nginx/conf.d/default.conf
    register: nginx_cust_config
  - name: Restart nginx to reflect changes
    systemd:
      state: restarted
      daemon_reload: yes
      name: nginx
    when: nginx_cust_config.changed
  - name: Set (httpd_can_network_connect) flag on and keep it persistent across reboots
    seboolean:
      name: httpd_can_network_connect
      state: yes
      persistent: yes
```
as you can see some additional lines have been added. A template is used to setup the http listener. The template ensures that your configuration file doesn't have to be static. In this case, you need to add the servers to loadbalance between. This is done by introducing a variable *wildfy_servers*, which you'll use when writing the template shortly. The configuration file is saved instead of the default.conf nginx template. Other approaches applies. Please refer to the nginx documentation for more information. If the configuration file is changed, a conditional expression (*when: nginx_cust_config.changed*) ensures, that the nginx process is restarted. Finally a SELinux rule has to be setup, to allow nginx to connect to port 8080.

After having extended the playbook to add the loadbalancer configuration, you need to add the template file for the configuration. First create a folder to store the template

```
$mkdir -u $WORK_DIR/roles/nginx/files
```

Then in your favorite editor save a file named *default.template* in dir *$WORK_DIR/roles/nginx/files* with the following content:

```
upstream backend {
{% for host in wildfly_servers %}
    server {{ hostvars[host].inventory_hostname }}:8080;
{% endfor %}
}
server {
    listen       80;
    server_name  localhost;
    
    access_log  /var/log/nginx/host.access.log  main;
    
    location / {
        proxy_pass http://backend;
    }
    
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

as you can see, the *wildfly_servers* variable is used to iterate over the servers with the wildfly application deployed.

Now test, that you can access the application on both application servers. In the command promt write:

```
$curl -w '\n' http://<server name for nginx server>/
```

you should get a different servername responding each time like in this output:

```
$ curl -w '\n' http://10.211.55.23/
Howdy at 2018-02-19T14:22:03.375+01:00.  Have a JDK class: javax.security.auth.login.LoginException (from jboss-server-2)
$ curl -w '\n' http://10.211.55.23/
Howdy at 2018-02-19T14:22:06.651+01:00.  Have a JDK class: javax.security.auth.login.LoginException (from jboss-server-3)
$ curl -w '\n' http://10.211.55.23/
Howdy at 2018-02-19T14:22:16.939+01:00.  Have a JDK class: javax.security.auth.login.LoginException (from jboss-server-2)
```

Optionally you can create a playbook to collect the two playbooks already made. If you want to do so, you can create a file named *main.yml* in *$WORK_DIR* with the following content:

```
---
- import_playbook: lb.yml
- import_playbook: site.yml
```

Otherwise you can wait for the section on Ansible Tower to see a way to manage your playbooks.
