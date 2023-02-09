variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "us-west-1" 
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "final-infrastructure-key" 
}

variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.micro" 
}

variable "security_group" { 
    description = "Name of security group" 
    default     = "l1-final-infrastructure-jenkins-sgroup" 
}

variable "tag_name" { 
    description = "Tag Name of for Ec2 instance" 
    default     = "l1-final-infrastructure-ec2-instance" 
} 
variable "ami_id" { 
    description = "AMI for Ubuntu Ec2 instance - Ubuntu server 22.04 LTS (HVM), 64 bit" 
    default     = "ami-09b2a1e33ce552e68" 
}
variable "versioning" {
    type        = bool
    description = "(Optional) A state of versioning."
    default     = true
}
variable "acl" {
    type        = string
    description = " Defaults to private "
    default     = "private"
}
variable "bucket_prefix" {
    type        = string
    description = "(required since we are not using 'bucket') Creates a unique bucket name beginning with the specified prefix"
    default     = "l1-final-infrastructure-s3bucket-"
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
/*
variable "DB" {
    NAME        = $DB_NAME
    USER        = $DB_USER
    PASSWORD    = $DB_PASSWORD
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}
*/
/*
name = "l1dbtest"
  username = "ams"
  password = "testpassword"

DB_NAME=WordpressTest
DB_USER=admin
DB_PASSWORD=01340134
DB_HOST=database-1.cde1mvsw4pqc.us-west-1.rds.amazonaws.com:3306
*/
#---- ----- end mysql database credentials ----- ----#