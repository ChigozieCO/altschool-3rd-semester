# Task

Host a static website in Amazon S3 Bucket and serve it using the Amazon Cloudfront.

# Instruction

Document the process in an md file with relevant screenshots and push to GitHub to be submitted before 10am, Saturday 11th May 2024.

# Solution

This assignment only requires the use of two AWS services, S3 and Cloudfront.

### Prereq

- You need to have an AWS account, the services used here are covered by the free tier and so you should not incur any costs. 

- If you are just creating your account ensure you create an IAM user that has administrator privilege (it's not recommended to use the root user for regular day to day activities) as well as an active access key.

- You need to have AWS CLI 2 installed and configured for programmatic access to your AWS account.

- You also need to have an HTML page (the static website you want to host), don't fret you don't have to start designing one if you don't have one handy you can get [html templates here](https://www.tooplate.com/). I will be using a template gotten from there as well.

## Amazon S3 Bucket

Amazon S3 (Simple Storage Service) is an object storage built to store and retrieve any amount of data from anywhere. It integrates with many other AWS services, is highly available and durable and also highly cost-effective. Amazon S3 also provides easy management features to organize data for websites, mobile applications, backup and restore, and many other applications. 

You can configure a storage bucket to host and serve as a static website, on a static website, individual webpages include static content. They might also contain client-side scripts. 

It however cannot be used to host a dynamic website as a dynamic website relies on server-side processing, including server-side scripts, such as PHP, JSP, or ASP.NET. Amazon S3 does not support server-side scripting, but AWS has other resources for hosting dynamic websites.

### Configure AWS CLI

I will be using the AWS CLI to programmatically create my bucket and upload the resources into the bucket as well as to enable static web hosting.

:zap: First you need to download the [aws cli 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). From the provided link follow the instructions for your device and follow along with the rest of the project.

:warning: **NOTE**

If you want to interact with AWS outside of the AWS Management Console and use the cli as I will be in this walkthrough you need to have programmatic access. You need to create an access key for the IAM user you will be using.

:zap: Simply navigate to the IAM user and scroll down to the `access key` and click on `create key`

(image 1)

For the use case select the first option being `Command Line Interface (CLI)` and click on `next`

(image 2)

You can choose add a tag or not (tags will make it easier for you to identify you access key) and then go ahead to create the key.

:zap: The next thing you need to do is to setup the cli for use. Use the `aws configure` command and enter your `access key`

```sh
$ aws configure
AWS Access Key ID [****************W0FM]: <your access key ID>
AWS Secret Access Key [****************okxa]: <your secret access key>
Default region name [us-east-1]: <whatever region you want to be your default>
Default output format [None]: <you can leave empty by clicking enter>
```

You can run the `aws sts get-caller-identity` command to verify that you have configured the cli correctly. The output of this command will display the present userid, account and Arn.

Verify that this is the correct credentials and continue.

Now you are ready to use the AWS CLI for this walk through.

### Create S3 Bucket

We will be creating a bucket with the default settings. We want our bucket to be private and to block all public access. 

Because we are serving the site through the content distribution network cloudfront (more on that later) we can afford to block all public access to our bucket as it won't be required.

To create a bucket via the cli, use the below command:

```sh
aws s3api create-bucket --bucket <your unique bucket name> --region <your preferred aws region>
```

:warning: **NOTE**

Your bucket name must be globally unique, no two buckets in the whole world can ever have the same exact name, there must be a variation.

Also if you set your default AWS region and you're ok with your bucket residing in that region you do not need to specify the region with the `--region` flag. Remember that your bucket is region specific so it will only exist in the region you created it.

I won't be using the region tag as I'm ok using my set default region.

```
aws s3api create-bucket --bucket altschool-sem3-site
```

If it was successful you should see something that resembles the below:

(image 3)

You can list your available buckets using `aws s3 ls` command.

(image 4)

### Upload Objects into S3

