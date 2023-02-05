terraform {
  backend "s3" {
    bucket = "final-infrastructure-tf-state-bucket"
    key = "main"
    region = "var.aws_region"
    dynamodb_table = "final-infrastructure-dynamo-db-table"
  }
}