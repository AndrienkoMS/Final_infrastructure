variable "aws_region" {
       description = "The AWS region to create things in." 
       default     = "us-west-1" 
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "l1_infrastructure_key" 
}

variable "db_instance_class" { 
    description = "instance class for database instance" 
    default     =  "t2.medium" 
}


variable "ami_id" { 
    description = "AMI for Ubuntu Ec2 instance - Ubuntu server 22.04 LTS (HVM), 64 bit" 
    #default     = "ami-09b2a1e33ce552e68" 
    default     = "ami-0db6edec9a19e887e" #Ubuntu server 22.04 + Docker CE + Docker Compose
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
  default = "wordpressdb.cde1mvsw4pqc.us-west-1.rds.amazonaws.com:3306"
}

variable "build" {
    type = string
    default = "default-build"
}
#---- ----- end mysql database credentials ----- ----#
#==== ===== deviding workspaces wariables ===== ====#
variable "db_identifier" {
  type = string
  default = "wordpressdb"
}
variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.medium" 
}
variable "db_subnet_group" {
  type = string
  default = "wp_subnet_group"
}
variable "iam_role_policy_name" {
  type = string
  default = "l1_infrastructure_ec2_policy"
}

variable "iam_instance_profile_name" {
  type = string
  default = "l1_infrastructure_ec2_profile"
}
#==== ===== end deviding workspaces wariables ===== ====#

#---- ----- docker credentials ----- ----#
