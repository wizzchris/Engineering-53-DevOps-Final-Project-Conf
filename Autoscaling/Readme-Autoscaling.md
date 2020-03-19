## Autoscaling

Amazon EC2 Auto Scaling helps you ensure that you have the correct number of Amazon EC2 instances available to handle the load for your application. You create collections of EC2 instances, called Auto Scaling groups. Before you can launch your Auto Scaling instances in a new VPC, you must *first create your VPC environment*. After you create your VPC and subnets, you launch Auto Scaling instances within the subnets.

#### Launch Configuration
We need to provide a Launch configuration resource. This provides a instance configuration template that an Auto scaling group
uses to launch a instance. This includes defining the AMI ID (image_id), Instance type and security group.
````
resource "aws_launch_configuration" "hamza-jason-eng53-config1" {
  image_id              = "${var.app_ami_id}"
  instance_type         = "${var.instance_type}"
  associate_public_ip_address = true
  user_data = "${var.user_data}"
````
user_data interpolates from the scripts/app/init.sh.tpl template file to install and start npm.

*Note:* You can specify your launch configuration with different multiple Auto scaling group, However you can only specify one launch configuration for a auto scaling group one at a time, and you cannot modify the launch configuration after you have created it.

#### Autoscaling group 
