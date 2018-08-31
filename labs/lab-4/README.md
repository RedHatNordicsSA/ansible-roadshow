# Writing the load balancer playbook

In the previous lab, we created two WildFly Swarm servers running our application. The next step is to setup a loadbalancer. We will use Nginx as the loadbalancer in this lab. Let's overview which part of the system which you will be working on.

![Overview of lab environment](../../content/images/app-arch2.png)

A role has already been written for installing Nginx with Ansible. The role can be found at the Ansible Galaxy site (https://galaxy.ansible.com/nginxinc/nginx/). [Ansible Galaxy](https://galaxy.ansible.com) is the place where roles and modules are shared. As always be critical when using content on the internet. When it comes to roles on Ansible Galaxy it's easy to do a quick review of the health of the role. 

![Evaluate quality of content](../../content/images/nginx.png)

Look at development activity of the role. Ansible Galaxy makes this evaulation easy by putting it on the front page of each role, as marked above. If there is not a lot of activity, there may be a risk that the role is not maintained or has not seen a lot of use.

First we need to install the role for Nginx. Run:

```
ansible-galaxy install nginxinc.nginx
```

and wait for the role to be installed. When that is done, we can use the role in our playbooks.

To install Nginx go to $WORK_DIR and create a new file named *lb.yml* with the following content:

```
---
- hosts: lbservers
  become: true
  name: Install NGNIX
  tasks:
  - include_role:
      name: nginxinc.nginx
```

Run the playbook with the command

```
ansible-playbook -i hosts lb.yml
```
You can again run the playbook multiple times, to ensure that this role is idempotent and that nothing changes the second or third time you run it.

This will install Nginx on the servers in the lbservers group. 
* To verify the installation, in your web browser, go to: *http://$loadbalancer1-ip-address*. 
![NGNIX welcome page](../../content/images/ngnix-welcome.png)
You should get the Nginx default page, as shown above. Take some extra time to appreciate how very simple it was to install the NGNIX software, even though you may never have done that before.

Next step is to configure Nginx as a loadbalancer for the two wildflyapp servers. To do so, we'll add an additional role for the configuration. We follow the [best practises for Ansible directory layout](http://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html) and place tasks, handlers, and vars in separate directories. This is done so that it's easier to collaborate and maintain your work. To create a boilerplate for our new role, which features these best practices, we use the ansible-galax command. Run below commands:

```
cd $WORK_DIR
ansible-galaxy init roles/nginx-config
```

First we'll create a handler for restarting the Nginx service in case of configuration changes. Define the handler in the file *$WORK_DIR/roles/nginx-config/handlers/main.yml* with the following content:

```
---
- name: restart-nginx-service
  systemd:
    state: restarted
    daemon_reload: yes
    name: nginx
```

This defines a handler named *restart-nginx-service*, which we'll use in a moment. Now edit the file *$WORK_DIR/roles/nginx-config/tasks/main.yml* to have the following content:

```
---
- name: Configure ngnix to listen for http
  template:
    src: default.template
    dest: /etc/nginx/conf.d/default.conf
  notify: restart-nginx-service
- name: Ensure nginx is started and persisted across reboot
  systemd:
    name: nginx
    enabled: yes
    masked: no
    state: started
- name: Set and persist httpd_can_network_connect SELinux flag for ngnix
  seboolean:
    name: httpd_can_network_connect
    state: yes
    persistent: yes
```
A template is used to setup the ngnix http listener. The template ensures that your configuration file doesn't have to be static. In this case, you need to add the servers to loadbalance between. This is done by introducing a variable *wildfy_servers*, which you'll use when writing the template shortly. The configuration file is saved instead of the default.conf nginx template. Other approaches applies. Please refer to the nginx documentation for more information. If the configuration file is changed, the previously defined handler (*notify: restart-nginx-service*) ensures that the Nginx process is restarted. Finally a SELinux rule has to be setup, to allow Nginx to connect to port 8080.

Define the variable *wildfly_servers* by replacing *$WORK_DIR/roles/nginx-config/vars/main.yml* with below content:

```
---
wildfly_servers: "{{ groups['wildflyservers'] }}"
```

Edit $WORK_DIR/lb.yml to include the newly created role:

```
---
- hosts: lbservers
  tasks:
  - include_role:
      name: nginxinc.nginx
  - include_role:
      name: nginx-config
```

After having extended the playbook to add the loadbalancer configuration, you need to add the template file for the configuration. In your favorite editor save a file named *default.template* in dir *$WORK_DIR/roles/nginx-config/templates/* with the following content:

```
upstream backend {
{% for host in wildfly_servers %}
    server {{ hostvars[host].ansible_host }}:8080;
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

as you can see, the *wildfly_servers* variable is used to iterate over the servers with the WildFly application deployed. Apply the new changes to the playbook by running the command:

```
ansible-playbook -i hosts lb.yml
```

Now test, that you can access the application on both application servers. In the command promt write:

```
curl -w '\n' http://<server name for nginx server>/
```

you should get a different servername responding each time like in this output:

```
$ curl -w '\n' http://10.211.55.23/
Howdy from unknown at 2018-02-19T14:22:03.375+01:00 (from jboss-server-2)
$ curl -w '\n' http://10.211.55.23/
Howdy from unknown at 2018-02-19T14:22:06.651+01:00 (from jboss-server-3)
$ curl -w '\n' http://10.211.55.23/
Howdy from unknown at 2018-02-19T14:22:16.939+01:00 (from jboss-server-2)
```

Finally create a playbook to collect the two playbooks already made, by creating a file named *main.yml* in *$WORK_DIR* with the following content:

```
---
- import_playbook: lb.yml
- import_playbook: site.yml
```

By running this playbook, you can setup everything with one command.

```
ansible-playbook -i hosts main.yml
```

```
End of lab
```
[Go to the next lab, lab 5](../lab-5/README.md)
