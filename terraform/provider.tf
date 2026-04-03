terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.39.0"
    }
  }

  backend "s3" {
    key = "vpc/state.tfstate"
  }

}
