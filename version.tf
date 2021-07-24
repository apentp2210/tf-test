terraform {
  required_version = ">= 1.0.2"

  required_providers {
    aws = {
      source = "hasicorp/aws"
      version = ">= 3.15"
    }
  }
}