terraform {
    backend "s3" {
        bucket = "app-tf-remote-backend-bucket-65746547674657465"
        key = "global/terraform.tfstate"
        region = "ca-central-1"
        #dynamodb_table = "app-tf-remote_backend_table"
    }
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "4.36.1"
        }
    }
}