provider "aws" {
  region = "ca-central-1"
}

resource "aws_s3_bucket" "remote_backend_bucket" {
  bucket = "app-tf-remote-backend-bucket-65746547674657465"
  tags = {
    Name        = "app-tf-remote_backend_bucket"
  }
}

/* resource "aws_dynamodb_table" "remote_backend_table" {
  name           = "app-tf-remote_backend_table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"
  

  attribute {
    name = "LockID"
    type = "S"
  }
} */