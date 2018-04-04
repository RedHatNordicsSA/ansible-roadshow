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
4. When you want to make a change to a file in a repository, you first make a local copy of the repository which is stored on your computer, you then change the file locally, commit the change locally and then go ahead and tell git to copy this local change to the repository. 

![Git basics](https://github.com/mglantz/ansible-roadshow/blob/master/content/git-repo.png?raw=true)

5. You may have different copies of a repository at the same time, these copies are called branches and are key when collaborating together with other people in the same repository. When copying content between branches, that is referred to as merging.

 ![Examples of commonly used git branches](https://github.com/mglantz/ansible-roadshow/blob/master/content/git-branches.png?raw=true)

6. This may seem a bit cumbersome, but you will get used to it. Promise.

If you are completely new to git and feel you need to review the basics, please go here: https://try.github.io and complete the excersises. 

# Git workflows
1. There are many different workflows for git which describes how to work with git
2. Some of these workflows are more complicated and all have their own challenges
3. Keeping things simple is good
4. You can always adapt things afterwards to fit your challenges better

# The GitHub workflow
1. Does not require GitHub, the workflow model is just called that
2. A very simple workflow
3. Master branch is always possible to release
4. Branches are where you develop and test new features and bugfixes
5. Yes, I wrote test. If you do not test your Ansible code you cannot keep the master branch releasable and this all fails.

 ![GitHub workflow branches](https://github.com/mglantz/ansible-roadshow/blob/master/content/git-branches.png?raw=true)

Now, as an exercise you will try out the GitHub workflow. Try to find a friend to do this exercise with.

# Working with your playbooks on GitHub
As an example of a git based version handling/collaboration system, we'll use GitHub for simplicity. As a first step, go ahead and create a new repository on GitHub and put the ping playbook [that you created in lab-2](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-2/README.md) there.

Next step, go ahead and make a change to your playbook via the GitHub web UI. When you commit the change, select 'Create a new branch for this commit and start a pull request.' as depicted below.

 ![Select a new branch](https://github.com/mglantz/ansible-roadshow/blob/master/content/new-branch.png?raw=true)
 
What happens next is that your change is copied into a copy of your repository. This is so that you and others can collaborate on this change, without affecting the code in the master copy (branch) of your repository.



