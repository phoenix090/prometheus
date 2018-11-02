# prometheus
Infrastructure As Code Project 2018

### To create a stack after cloning
###### openstack stack create -t iac_heat/iac_top.yaml -e iac_heat/iac_top_env.yaml < name-of-the-stack >

### Commands you have to run on manager to get prometheus going
###### puppet appy /var/tmp/r10k.pp
###### cd /etc/puppetlabs/code/environments/h_testing
###### puppet apply --environment h_testing manifests/site.pp

### On all other nodes, you need to do one command
###### puppet agent -t --environment h_testing

### To run validation and unit test, type following commands
###### puppet validate manifest/*
###### pdk validate puppet
###### pdk test unit

