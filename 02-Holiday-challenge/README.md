# Task

You are required to perform the following tasks

1. Set up 2 EC2 instances on AWS (use the free tier instances).

2. Deploy an Nginx web server on these instances (you are free to use Ansible).

3. Set up an ALB (Application Load balancer) to route requests to your EC2 instances.

4. Make sure that each server displays its own Hostname or IP address. You can use any programming language of your choice to display this.

# Instruction

Important points to note:

1. I should not be able to access your web servers through their respective IP addresses. Access must be only via the load balancer.

2. You should define a logical network on the cloud for your servers.

3. Your EC2 instances must be launched in a private network.

4. Your Instances should not be assigned public IP addresses.

5. You may or may not set up auto scaling(I advice you do for knowledge sake).

6. You must submit a custom domain name(from a domain provider e.g. Route53) or the ALB’s domain name.

# Solution

This project would be a walk in the park for me were I to configure it via the AWS Management console and so I have decided to challenge myself by carrying out all my configurations in via the AWS CLI.

You can find the article on the step by step process of my configuration [here]().

This repo will also contain the CLI commands I ran for every aspect of the configuration.