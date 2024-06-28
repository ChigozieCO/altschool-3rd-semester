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

# Create S3 Bucket Module

