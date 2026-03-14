//State locking 
//Keep track all rescources terraform is managing
//When multiple developers working on terraform project lock state if someone
//is doing a terraform apply 

provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "travel-ease-state-locking-bucket"
    key    = "terraform-state"
    region = "eu-west-1"

    //New flag to enable S3 native lock file 
    use_lockfile = true

  }
}



