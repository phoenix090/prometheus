# prometheus
Infrastructure As Code Project 2018

In this group project we had the assignment to deploy Prometheus and Grafana with the configuration managment system Puppet.

### To create a stack and run prometheus and grafana after cloning this repo, type only this command:
###### openstack stack create -t iac_heat/iac_top.yaml -e iac_heat/iac_top_env.yaml << name-of-the-stack >>
- Now you need to wait like 30-40 minutes and everything should be up and running after that.

### To run validation and unit test, type following commands
###### puppet validate manifest/*
###### pdk validate puppet
###### pdk test unit

### If you want to scale up the infrastructure/ nodes, you need to configure the following files:
##### 1. Modify the iac_heat/iac_infraservices.yaml
##### 2. Put the name of the nodes you added in the file above to the manifests/site.pp and assign it with a role
##### Lets say i want to create another node named node3, you need to put something like this in manifests/site.pp
node 'node3.borg.trek' {
  include ::role::node_exporter
}



