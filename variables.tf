variable "global" {
  type = "map"
  default = {

    ## Name Tagging 
    app_name      = "dev-vpc"
    vpc_name      = "vpc" 
    env           = "dev"
    subnets_name  = "subnet"

    ## Region
    region       = "us-west-1"
    azs         = "us-west-1a,us-west-1c"
    ami_id      = "ami-73f7da13"

    ## Networking
    vpc_cidr    = "10.0.0.0/16"
    subnets_ext  = "10.0.10.0/24,10.0.11.0/24"  
    subnets_int  = "10.0.20.0/24,10.0.21.0/24" 

    ## tfstate info
    bucket_name = "mycompany-builds"
  }
}
