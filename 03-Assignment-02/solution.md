# Terraform Provider and Initialize Terraform

To begin I will create a `main.tf` file and a `provider.tf` file for my root module. The first order of business is to configure the AWS provider for Terraform and initialize to get it ready to deploy AWS resources.

A provider is used by Terraform to interface with the API of whatever infrastructure you're trying to build. Since we are trying to build AWS infrastructure we will be using the AWS infrastructure for our configuration. If you were building in GCP or Azure you will be using a provider for those cloud services.

In the `provider.tf` file I will add the terraform block as well as the provider block, the terraform code block will allow terraform use the the AWS API build our infrastructure while the provider block will configure the AWS provider with the necessary credentials.

In the `provider.tf` file add the following lines of code:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}
```

The great thing about terraform is that you do not have to have any of these codes memorized as you just start out with terraform, you can always refer to the [Terraform documentation](https://developer.hashicorp.com/terraform/docs) for help. 

In the terraform block I specified AWS as the required provider with source as `hashicorp/aws` but I omitted the `version` argument as I would like terraform to download the latest version whenever it is initialized.

The provider block provides the information needed to access AWS specifically. In the provider block I specified the `region` argument, that is the only credential I will be hardcoding in my configuration. As I have already setup my AWS credentials using `AWS configure` with the AWS CLI  I added the `shared_credentials_file` argument (if you have multiple profiles ensure you include the `profile` argument and supply the profile name) so Terraform will use that information to pick up these credentials and make use of them to build our infrastructure.

For a guide on how to configure your AWS credentials in the AWS CLI, check out [this post](https://dev.to/chigozieco/host-a-static-website-using-amazon-s3-and-serve-it-through-amazon-cloudfront-3om8#configure-aws-cli) of mine where I take you through the process.

Now I am ready to run a `terraform init` to initialize the project so that terraform can download the provider required for this project and connect to AWS.

Ensure you are in your project directory and run the below command in your terminal:

```sh
terraform init
```

(image 1)

# Terraform Modules

Terraform modules are a powerful feature that allows you to organize and reuse infrastructure configurations. Modules encapsulate groups of resources that are used together and can be referenced and instantiated multiple times within your Terraform configuration.

Modules are a great way to follow the `Don't Repeat Yourself` (DRY) principle of software development which states that code should be written once and not repeated. Modules encapsulate a set of Terraform config files created to serve a specific purpose.

Modules are used to create reusable components inside your infrastructure. There are primarily two types of modules depending on how they are written (root and child modules), and depending if they are published or not, we identify two different types as well (local and published).

Reusability is the best consideration while writing Terraform code. Repetition of the same configuration will be laborious because HCL is a declarative language and can be very wordy. Therefore, for optimal reusability, we should attempt to use modules as much as possible so be sure to define them at the beginning, as much as possible. 

We will be writing our configuration as modules and then run the modules to build the configuration.

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

To begin I created the `Modules` directory, this is where all my modules will reside.

# Create S3 Bucket Module

For my S3 bucket module, I created a directory named `s3-bucket` in the `Modules` directory. In this directory I create  the following files `main.tf`, `variables.tf`, `output.tf`.

## Create S3 Bucket

#### modules/s3-bucket/variables.tf

In the `variables.tf` I define the bucket name as a variable with the code below:

```hcl
variable "bucket-name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket-name) >= 3 && length(var.bucket-name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket-name))
    )
    error_message = "The bucket name must be between 3 and 63 characters, start and end with a lowercase letter or number, and can contain only lowercase letters, numbers, hyphens, and dots."
  }
}
```

The validation simply checks that the bucket name is between 3 and 63 characters, start and end with a lowercase letter or number, and contains only lowercase letters, numbers, hyphens, and dots. This is necessary to prevent any error that AWS might throw as a result of wrong bucket naming convention.

The significance of using a variable file is for simplicity and easy refactoring of the code. In the event that we need to change the value of that variable, we will only need to change it in one place and the change will be picked up anywhere that variable is made reference to using the `.var` notation.

#### modules/s3-bucket/main.tf

Now to the creation of the S3 bucket, we will add the `aws_s3_bucket` resource block to the module's `main.tf` file as shown below.

```hcl
resource "aws_s3_bucket" "site-bucket" {
  bucket = var.bucket-name
  force_destroy = true
}
```

The bucket name is supplied by a variable and will be substituted with the value at creation.

#### `modules/s3-bucket/outputs.tf`

This is the file in which we will output some of the values we will use in the rest of our configurations.

Go ahead and create a new file called `outputs.tf` in the s3 bucket module add the below code to the file:

```hcl
output "bucket_regional_domain_name" {
  description = "This is the bucket domain name including the region name."
  value = aws_s3_bucket.site-bucket.bucket_regional_domain_name
}
```

## Add the S3 Bucket to the Root Module

#### `main.tf`

To test that this module works we will create an s3 bucket using this module we have jut written. Head to the `main.tf` file of your root module, outside your `Module` directory and enter the below piece of code in the file.

```hcl
module "s3-bucket" {
  source = "./Modules/s3-bucket"
  bucket-name = var.bucket-name
}
```

#### `variables.tf`

Create three new files also in your root module called `variables.tf`, `outputs.tf` and `terraform.tfvars`.

In the `variables.tf` add the code below

```hcl
variable "bucket-name" {
  type = string
}
```

#### `outputs.tf`

In the `outputs.tf` add the following code:

```hcl
output "bucket-name" {
  value = module.s3-bucket.site-bucket.bucket_regional_domain_name
}
```

We will make use of this output when creating our cloudfront distribution.

#### `terraform.tfvars`

In the `terraform.tfvars` file, enter the code below:

```
bucket-name = "<your unique bucket name>
```

:warning: **NOTE**

Your `.tfvars` file should never be committed to version control, ad this file to your `.gitignore` file. Check out my [`.gitignore` file](https://github.com/ChigozieCO/altschool-3rd-semester/blob/main/03-Assignment-02/.gitignore) for files to add to yours.

You can also use [this site](https://www.toptal.com/developers/gitignore/) to generate your gitignore files for this project and future projects.

In your terminal, run the `terraform init` command again, your must rerun the command when you add a module or change provider. If you fail to run it and run any other terraform command you will get the below error message.

(image 2)

Now you can run `terraform plan` to see what terraform plans to create in your AWS account. 

To create the bucket, run 

```sh
terraform apply
``` 

Whenever you run this command terraform will always ask you if you want to carry out this action, you can either answer yes or no. To avoid this question coming up you can directly include `auto approve` in the command as shown below:

```sh
terraform apply --auto-approve
```

If you followed along correctly, you would have successfully created an s3 bucket, we will destroy it and continue writing our terraform script as we are not just merely creating a bucket. 

Run the command below to destroy the created bucket:

```sh
terraform destroy
```

## TF alias for Terraform

Before we continue, I want to set a short alias for terraform as we will need to call terraform a whole lot. Setting terraform alias to be `tf` will help simplify things for us when we are calling our commands, so we will no longer need to explicitly call out `terraform` but now we call it `tf` eg `tf apply` instead of `terraform apply`. It helps us shorten our command.

We can do this by setting up an alias in the bash profile.

To open the bash profile for the terminal, I used the below command:

```sh
vi ~/.bash_profile
```

This is where we can set bash configurations, we set our alias by calling alias with the short form as seen:

```sh
alias tf="terraform"
```

To now use the command we set as alias we need to run that bash profile script first so that the change is applied.

```sh
source ~/.bash_profile
```

Now I can use tf instead of terraform

## Upload Assets Into S3 Bucket

Before writing the code to upload our website assets into the bucket we should create a directory and save our assets. I will save this in our root module as `web-assets` and add my website assets in there.

#### modules/s3-bucket/main.tf

We will use the `for_each` meta arguments to upload our bucket assets, we are using this approach as we have multiple files to upload. this is useful when you create multiple resources with similar configurations. 

It does not make sense to just copy and paste the Terraform resource blocks with minor tweaks in each block. Doing this only affects the readability and unnecessarily lengthens the IaC configuration files. Add the below code to your s3-bucket module `main.tf` file:

```hcl
# Upload objects into the s3 Bucket
resource "aws_s3_object" "upload-assets" {
  for_each = fileset("${var.web-assets-path}", "**/*")
  bucket = aws_s3_bucket.site-bucket.id
  key = each.value
  source = "${var.web-assets-path}/${each.value}"
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")
}
```

The `for-each` will iterate through the files in the website directory. I used the `fileset` function to iterates over all files and directories in the specified path, making each file/directory available to the for_each loop in the resource definition. 

The path isn't hardcoded, it is defined as a variable in the `variable.tf` file as you will see below.

The `for_each` loop over `fileset` returns file paths, not key-value pairs, this is why we use `each.value` as our key and not `each.key`.

We want the website to recognise each file type for it's correct respective MIME type an display it properly on the website and that is why we used the `lookup` function in the `content_type` argument. `lookup(map, key, default)` is a function that searches for key in map and returns the associated value if found. If key is not found, it returns default.

The regex function extracts the file extension from each.value, which is the file name obtained from fileset in other to determine a more accurate MIME type.

#### modules/s3-bucket/variables.tf

Here we will define the variables we called in the piece of code above, add the below code to the file:

```hcl
# Set the variable for the file path of the files to be uploaded to the bucket
variable "web-assets-path" {
  description = "This is the location of our website files"
  type = string
}

variable "mime_types" {
  description = "Map of file extensions to MIME types"
  type        = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".pdf"  = "application/pdf"
    "json" = "application/json"
    "js"   = "application/javascript"
    "gif"  = "image/gif"
    # Add more extensions and MIME types as needed
  }
}
```

## Update Root Module `main.tf`, `variable.tf` and `terraform.tfvars` Files

#### `main.tf`

we updated our module and so we need to update our root module configuration as well. Your root module's `main.tf` file should now look like this:

```hcl
module "s3-bucket" {
  source = "./Modules/s3-bucket"
  bucket-name = var.bucket-name
  web-assets-path = var.web-assets-path
}
```

#### `variable.tf`

Your root module's `variable.tf` file should now look like this:

```hcl
variable "bucket-name" {
  type = string
}

variable "web-assets-path" {
  type = string
}
```

#### `terraform.tfvars`

Your root module's `terraform.tfvars` file should now look like this:

```
bucket-name = "<your unique bucket name>
web-assets-path = "<the path to your website files>
```

# Create CloudFront Module

