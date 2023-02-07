terraform {
  backend "s3" {
    bucket = "l1-final-infrastructure-tf-state"
    key = "dev/terraform.tfstate"
    region = "us-west-1"
    #dynamodb_table = "final-infrastructure-dynamo-db-table"
  }
}