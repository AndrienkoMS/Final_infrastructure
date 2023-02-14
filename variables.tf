variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "us-west-1" 
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "l1_infrastructure_key" 
}

variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.micro" 
}

variable "tag_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "WordpressInstance" 
} 
variable "ami_id" { 
    description = "AMI for Ubuntu Ec2 instance - Ubuntu server 22.04 LTS (HVM), 64 bit" 
    #default     = "ami-09b2a1e33ce552e68" 
    default     = "ami-0db6edec9a19e887e" #Ubuntu server 22.04 + Docker CE + Docker Compose
}
variable "versioning" {
    type        = bool
    description = "(Optional) A state of versioning."
    default     = true
}

variable "tags" {
    type        = map
    description = "(Optional) A mapping of tags to assign to the bucket."
    default     = {
        environment = "dev"
        terraform   = "true"
        project     = "final"
    }
}
#---- ----- mysql database credentials ----- ----#
# data is stored in jenkins credentials => exported to ubuntu environment => imported to tf file
variable "dbname" {
  type = string
}

variable "dbuser" {
  type = string
}

variable "dbpassword" {
  type = string
}

variable "dbhost" {
  type = string
  default = "database-1.cde1mvsw4pqc.us-west-1.rds.amazonaws.com:3306"
}

/*
DB_NAME=WordpressTest
DB_USER=admin
DB_PASSWORD=01340134
DB_HOST=database-1.cde1mvsw4pqc.us-west-1.rds.amazonaws.com:3306
*/
#---- ----- end mysql database credentials ----- ----#
#---- ----- docker credentials ----- ----#
