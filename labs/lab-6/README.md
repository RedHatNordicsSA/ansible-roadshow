# Working with Ansible as code
A challenge when doing larger scale automation is to enable collaboration for people to work on the same pieces of automation together. Luckily for us, programmers has since long solved this issue for us using version handling systems, such as git.

Ansible does not require you to use git version handling, but there are some good reasons why you should familiarize yourself with it.

When you scale out your Ansible usage (aka. automate all things) you’ll have many different teams collaborating, and:
1. Git was invented to solve common collaboration challenges
2. Git has earned its worldwide popularity the hard way and is in the core of many of the world’s most popular collaboration services and products

Take some time and think about the different teams or people that you would like to collaborate with, or what teams you would need to collaborate with in order to automate your complete enterprise.

 ![Examples of different teams in a company](https://github.com/mglantz/ansible-roadshow/blob/master/content/different-teams.png?raw=true)

# What is git and how does it work?
1. A git repository stores files
2. Access controls are specific to repositories
3. All changes to all files are tracked
4. When you want to make a change to a file in a repository, you first make a local copy of the repository which is stored on your computer, you then change the file locally, commit the change locally and then go ahead and tell git to copy this local change to the repository. This may seem a bit cumbersome, but you will get used to it.

 ![Git repo basics](https://github.com/mglantz/ansible-roadshow/blob/master/content/git-repo.png?raw=true)

If you are completely new to git and feel you need to review the basics, please go here: https://try.github.io and complete the excersises. 


