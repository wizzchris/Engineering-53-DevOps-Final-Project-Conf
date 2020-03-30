# Mutli-AZ Application feature

To make the application *highly available* and have redundancies across all 3 availability zones. When we distribute the instances across the other
availibility zones, if 1 fail, the other instances in the other availability zones can handle the request.

## Load Balancer and Autoscaling Group for this 2 tier architecture 

### Autoscaling
Amazon EC2 Auto Scaling helps you ensure that you have the correct number of Amazon EC2 instances available to handle the load for your application. You create collections of EC2 instances, called Auto Scaling groups. Before you can launch your Auto Scaling instances in a new VPC, you must *first create your VPC environment*. After you create your VPC and subnets, you launch Auto Scaling instances within the subnets.

##### Launch Configuration
We need to provide a Launch configuration resource. This provides a instance configuration template that an Auto scaling group
uses to launch a instance.

user_data interpolates from the scripts/app/init.sh.tpl template file to install and start npm (starts web server).

##### Autoscaling groups
The autoscaling group scale the load to a fixed number of 3 instances.
