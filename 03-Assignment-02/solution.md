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
  shared_credentials_files = "~/.aws/credentials"
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
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
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
  bucket = var.bucket_name
  force_destroy = true
}
```

The bucket name is supplied by a variable and will be substituted with the value at creation