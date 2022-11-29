terraform {
  backend "s3" {
        bucket = "test-tf-remote-backend-bucket-111647882835674839238"
        key = "infra/terraform.tfstate"
        region = "ca-central-1"
        dynamodb_table = "remote_backend_table"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.36.1"
    }
    http = {
      source = "hashicorp/http"
      version = "3.1.0"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}