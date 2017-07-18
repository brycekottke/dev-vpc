terraform {
  backend "s3" {
    bucket = "mycompany-builds"
    key    = "dev-vpc/dev-vpc.tfstate"
    region = "us-east-1"
  }
}
