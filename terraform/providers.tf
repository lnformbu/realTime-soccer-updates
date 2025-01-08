terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66, < 5.67.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
  # uncomment to use terraform cloud as backend

  # cloud {
  #   organization = ""
  #   workspaces {
  #     name = ""
  #   }
  # }

}



provider "aws" {
  region = "us-east-1" # Change this to your preferred AWS region
}