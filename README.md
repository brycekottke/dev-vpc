## README ##

### Description ###
This repo is intended to setup and configure a VPC environment for High Availability. Below is a description of what the terraform code will stand up, and how to go about deploying it. This will be a little different than the way applications will be deployed simply because it is the networking infrastructure that application instances will be deployed to.
   
What you'll need:
  - terraform
  - awscli
  - configure your awscli credentials to talk to the AWS API (~/.aws/credentials)
  - more info: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
   
Steps terraform will take:
  - Create VPC
  - Create 2 External Subnets
  - Create 2 Internal Subnets
  - Create AWS NAT Gateway
  - Create 2 EIP's and Associate with NAT Gateway

### Deploy ###
  - Create S3 Bucket to store terraform .tfstate file

```
$ vi create_s3_bucket.sh
      s3_bucket='terraform-builds'
      profile='development'

$ ./create_s3_bucket.sh
```
  - Create VPC Environment with terraform

There is an extra step when deploying the VPC with terraform since there is currently no networking infrastructure stood up yet. Follow the steps below to stand up the Networking infrastructure.
   
Modify the **remote.tf** file with appropriate settings. This will only need to be done when standing up the VPC. Application deployment should not need this.
```
terraform {
  backend "s3" {
    bucket = "mybucket-builds"
    key    = "dev-vpc/dev-vpc.tfstate"
    region = "us-east-1"
  }
}
```
   
Modify **variables.tf**. This is the 'goto' file for managing your input variables. I've explained a bit in detail with comments.
```
variable "global" {
  type = "map"
  default = {

    ## Name Tagging
    app_name      = "dev-vpc"   # keep this the repo name for consistency
    vpc_name      = "vpc"       # name of your vpc
    env           = "dev"       # the name of your environment
    subnets_name  = "subnet"    # the name of your subnets

    ## Region
    region       = "us-west-1"              # the region you want to deploy to
    azs         = "us-west-1a,us-west-1c"   # the availability zones. (make sure they are available in AWS first)
    ami_id      = "ami-73f7da13"            # the AMI image you want to use for your ec2 instances

    ## Networking
    vpc_cidr    = "10.0.0.0/16"                 # your VPC CIDR (Can leave alone)
    subnets_ext  = "10.0.10.0/24,10.0.11.0/24"  # your External Subnet Ranges (add more with a ",")
    subnets_int  = "10.0.20.0/24,10.0.21.0/24"  # your Internal Subnet Ranges (add more with a ",")

    ## tfstate info
    bucket_name = "mycompany-builds"    # the name of your bucket to store .tfstate files. 
                                          # this will create a sub directory of ${app_name}
  }
}

```

Run terraform commands to stand up the VPC infrastructure
```
$ terraform init
$ terraform plan -out=create.tfplan
$ terraform apply create.tfplan
```
