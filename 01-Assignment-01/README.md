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

Now we need to upload our static website assets.

A static webpage is one that is sent to a web browser in its identical stored format. It is sometimes referred to as a flat page or a stationary page.

Until the site is redesigned or the site administrator makes changes directly in the code, the page will not be altered by anything either the user or the site administrator does on the page.

Our static website assets are our html, css etc, those files you downloaded from the [html templates here](https://www.tooplate.com/).

Time to upload our objects in the S3 bucket, we do that using the code below:

```sh
aws s3 cp /local/file/path s3://bucket-name --recursive

aws s3 cp ./2093_flight/ s3://altschool-sem3-site --recursive
```

The recursive flag will help us upload multiple files at the same time, it will ensure that all the files and subdirectories within the specified directory are uploaded.

(image 5)

To verify that you have successfully uploaded the objects we will list the objects available in the bucket.

Use the command below to do that:

```sh
aws s3 ls s3://bucket-name

aws s3 ls s3://altschool-sem3-site
```

(image 6)

You should see a list of the objects you just uploaded into your bucket. From the screenshot above you can see my uploaded objects.

## Amazon CloudFront

Amazon CloudFront is a content delivery network operated by Amazon Web Services. It is a service that helps you distribute your static and dynamic content quickly and reliably with high speed by using a network of proxy servers to cache content, such as web videos or other bulky media, more locally to consumers, to improve access speed for downloading the content.

We will use the management console for this, log in with your IAM user and navigate to cloudfront under the Networking & Content Delivery category.

When you load the cloudfront page click on `create distribution`

(image 7)

### CloudFront configurations

- ### Origin

:zap: #### Origin Domain

Origins are where you store the original versions of your web content. CloudFront gets your web content from your origins and serves it to viewers via a worldwide network of edge servers.

The origin domain is the DNS domain name of the Amazon S3 bucket or HTTP server from which you want CloudFront to get objects for this origin.

To that effect select the S3 Bucket we created earlier, from the dropdown, as your `origin domain

:zap: #### Origin path

Leave this blank, as is.

:zap: #### Name

This will automatically be filled in when you enter your origin domain

(image 8)

:zap: #### Origin Access

In other to further restrict the access to our Amazon S3 bucket origin to only specific CloudFront distributions we will set our `origin access` to the AWS recommended setting which is `Origin access control settings`

Once that is selected, we will create a new Origin access control settings.

Select the `Origin access control settings` radio button and then click on `Create new OAC`

(image 9)

The pop up that appears when you click on create new OAC will be populated with the necessary details, leave it as is and click on `Create`

(image 10)

As soon as this new AOC is created, you will see an warning (same as shown below) telling you that you will need to update your bucket policy with the policy that will be provided after the distribution is created.

(image 11)

- ### All Other Config

For the Web Application Firewall, select `do not enable security protections`, You could actually choose to enable it if you want I am just trying to be safe and not incur any unexpected costs.

The last setting you will be changing is the `default root object` type in `index.html`. This will enable cloudfront serve your index page to your site visitors.

Leave all other configurations in their default settings, those settings work just fine for what we are trying to do.

Your configuration should look like the screenshots below:

(image 12 - 17)

Scroll down to the bottom of the page and click `create distribution`

(image 18)

Copy the provided policy, you can see it highlighted in yellow on your screen, see screenshot above for the item labelled `1` to know where to locate it.

After copying the policy click on the link to take you to the bucket in order to update the permissions with the policy you just copied.

## Update Bucket Policy With Necessary Permission

You could either manually navigate to the S3 bucket we have been using for this project or you could click on the link in the above picture labelled 2 to take you directly to the bucket.

Once the bucket is open, click on the permissions tab. 

(image 19)

Scroll down to `Bucket Policy` and click on `edit` to add the permissions we copied at the end of the cloudfront distribution creation.

(image 20)

The copied policy is shown below, ensure you use the one you copied from your cloudfront console as it will carry your unique ARN.

```json
{
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::altschool-sem3-site/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::<redacted>:distribution/EOE3G4O3YYZSA"
                    }
                }
            }
        ]
      }
```

Now save your changes.

Your bucket policy should now look like this:

(image 21)

## Access Your Site

Head back to your cloudfront console and retrieve your distribution domain name as shown in the image below.

(image 22)

This is the address you will enter in your browser to be able to see your website.

We can see from the screenshot below that cloudfront is serving the webpage correctly without have to unblock public access of our bucket.

(gif)

And that's it!! We have successfully served a static webpage using Amazon S3 and Amazon CloudFront.