# Installing wildfly and nginx from Tower

As the good developer you are, you want to make your playbooks available for the whole organization to run and benefit from. This lab will describe how you can do so.

First create a new git repo with $WORK_DIR as root directory. If you did [lab 6](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-6), you can reuse that repo. If you don't want to spend time on git right now, you can use the one [provided by your instructor](https://github.com/jacobborella/ansible-roadshow-test).

Next you need to instruct Ansible Tower to use the nginx module. You could install the module on Tower as previously, but this would have the unwanted effect that all projects on the Tower server would rely on this module. Furthermore the Tower server now needs special care if you need to reinstall it. Instead we'll instruct Tower to include the nginx module as part of our project. To do so, add a file *$WORK_DIR/roles* called *requirements.yml*, with the following content
```
---
- src: https://github.com/nginxinc/ansible-role-nginx
  version: master
  name: nginxinc.nginx
```
Check in the change and you are ready to go.

Login to the Ansible Tower server on the url and username/password provided by the instructor. If you haven't setup the credentials to your system as described in the lab [Introducing Ansible Tower](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-7), please do so now:-)

First step is to add your code to Tower in form of a project. In this case we'll add the code in form of the git repo, you created earlier.
First click *PROJECTS* in the top menu. Then click *ADD*. Finally fill in values as provided in below screenshot (replace git url with your repo url)
![filling in project values](images/img2.png)
Finally click *SAVE*

Now your code should be fetched into Tower for use. You can verify this has happened by clicking *PROJECTS* menu item and verify there is a green dot left to your project name.

Next we need to define our inventory. This is the same as using the hosts file, but to have everything under control in Tower, we'll use this mechanism. Click on the *INVENTORIES* menu item, click the green *ADD* button and select *Inventory* from the list. Name the inventory *Ansible Workshop machines* and click *SAVE*. Next select the *GROUPS* tab 
![filling in groups](images/img3.png)

Add three groups
* dev
* lbservers
* wildflyservers

![groups done](images/img4.png)

Now select the *HOSTS* tab and add the three hosts, which has been assigned to you by the instructor.

When that's done, we need to associate the hosts with the groups. This is most easily done by clicking 'Ansible Workshop machines' in the breadcrumb near the top of the screen.
![hosts done](images/img5.png)

then select the *GROUPS* tab. Then click on the dev group and then the *HOSTS* tab. Now click *ADD* and select existing host. This will give you a menu, where you can select the hosts. For dev select all hosts and click *SAVE*.
![dev group hosts](images/img6.png)

Repeat the process for lbservers and wildflyservers, but this time only select the appropriate machines as in the *hosts* file.

Phew that's a lot of work. Luckily there is other ways of doing this, but the GUI is the easiest way to help you understand what's going on. Maybe grap a cup of cofee at this point - almost there.

The template is where it all comes together. So now click the *TEMPLATES* menu item and click *ADD* and select *Job Template*. Fill in values as below
![wildfly template](images/img7.png)
be aware that in order to select the credentials, you must use the search button and select credential type as appopriate.

![lb template](images/img8.png)

Now you should be able to launch your playbooks. Click the *TEMPLATES* menu item. Then click the rocket to the right of the 'Install Wildfly App' template.

![wildfly template](images/img9.png)

This should succeed succesfully. Do the same for the other template.

Last step is to create a workflow to pull it all together. To do this, you can create a Workflow Template. So click on the *TEMPLATES* menu item and select *ADD - Workflow Template*. Name the template 'Install full application stack' and click *SAVE*. Now the *WORKFLOW EDITOR* button is active. Click on the button. This will take you to the following screen

![template editor](images/img10.png)

if you now click the *START* button, you get to invoke a template. On the right side of the screen, you can select the 'Install Wildfly App' template and click *SELECT*. This will add the template to the workflow. When you move the cursor over the added template, a plus sign appears to the right on the box. Click it and a new template is added. Using the same method choose 'Install load balancer' as the template. This template should only run if the previous succeeded. At this time your workflow should look like this

![template editor](images/img11.png)

Now you can run the workflow template as any other template. Nifty right?

You can also run templates in parallel and sync projects with the repos. If you have spare time, try playing with the features.

```
End of lab
```
[Go to the next lab, lab 9](../lab-9/README.md)
