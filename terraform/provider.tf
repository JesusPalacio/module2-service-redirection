terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
  bucket = "redirect-module-tfstate"
  key    = "terraform.tfstate"
  region = "us-west-1"
}

}

provider "aws" {
  region = "us-west-1"
}
