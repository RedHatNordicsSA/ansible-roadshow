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

>If you are completely new to git and feel you need to review the basics, please go here: https://try.github.io and complete the excersises. 

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
As an example of a git based version handling/collaboration system, we'll use GitHub for simplicity.

>As a first step, go ahead and create a new repository on GitHub and put the ping playbook [that you created in lab-2](https://github.com/mglantz/ansible-roadshow/tree/master/labs/lab-2/README.md) there.

>Next step, go ahead and make a change to your playbook via the GitHub web UI. When you commit the change, select 'Create a new branch for this commit and start a pull request.' as depicted below.

 ![Select a new branch](https://github.com/mglantz/ansible-roadshow/blob/master/content/new-branch.png?raw=true)
 
What happens next is that your change is copied into this new copy of your repository, called a branch. This is so that you and others can collaborate on this change, without affecting the code in the master branch (copy) of your repository. This allows your master branch to be stable, while development is ongoing. This also allows for several people to work on the code in your repository, at the same time.

>Now click on 'Create pull request' to complete the creation of the new branch and copying your change to it.

 ![Creating a pull request](https://github.com/mglantz/ansible-roadshow/blob/master/content/pull-request.png?raw=true)

You will now get redirected to the page with overviews your pull request. Here you can use the comment function displayed in the 'Conversation' tab to collaborate with other people. Perhaps your change needs a code review or you need some advise on how to solve a specific problem? The 'Commits' and 'Files changed' allows you to overview all changes made into your newly created branch, from now on.

>Explore the 'Conversation' feature and try add yet another change to your playbook and review how all your changes are visible on the pull request page.

The pull request has yet another function, which is to allow someone else than you to approve changes, before they get copied into your master branch. Normally, not everyone has access to 'Merge pull request' which will copy all your changes into the master branch from this temporary branch where you do your work.

>After having merged your work, select to delete your branch. 

 ![Deleting your branch](https://github.com/mglantz/ansible-roadshow/blob/master/content/delete-branch.png?raw=true)
 
 The reason why you delete your branch afterwards is because that allows people to see when work has been completed. Also, it allows someone to overview the status of the development work being done. For example, if a branch has lived on for too long, the risk of merge conflicts (when several people has changed the same files) becomes greater. Because of that and because code quality usually suffers when you do too much work at once, try biting off a good sized chunk of work. It's better that you do several smaller chunks of work than one huge chunk which takes a long time to do.
 
 




