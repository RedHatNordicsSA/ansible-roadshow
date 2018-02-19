Magnus:
* Automatically deploy instances and all infra stuff
* Integrate with DNS
* Create Tower DB backup to load after install and add to playbook

Jacob/Magnus:
* Excercise needs description of, what it is the participant is building

Jacob:
* Ensure that wildfly comes up in case of a restart (lab 3)
* Add some content about error handling and how this is much better than with shell script.
* Ensure wildflyapp service restarts when new war file is deployed (maybe as an extra assignment to show ansible conditionals, etc?)
* Maybe start by adding one server with wildfly and add other server later to show idempotence
* Preconfigured Profile to run EAP / undertow as a load balancer.
* loadbalancer need to use roles instead of having everything in lb.yml
