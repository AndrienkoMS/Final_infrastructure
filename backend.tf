terraform {
  backend "s3" {
    bucket = "final-infrastructure-tf-state-bucket"
    key = "main"
    region = "us-west-1"
    dynamodb_table = "final-infrastructure-dynamo-db-table"
  }
}