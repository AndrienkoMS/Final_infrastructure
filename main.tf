provider "aws" {
  region = var.aws_region
}


#Create RDS MySQL database to store wordpress data
resource "aws_db_instance" "default" {
  identifier = "l1-mysql-db"
  engine = "mysql"
  engine_version = "8.0.28"
  instance_class = "db.t2.micro"
  name     = var.dbname
  username = var.dbuser
  password = var.dbpassword
  allocated_storage = 5
  #parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}


#IAM role to attach to ec2 to connect to DB
resource "aws_iam_role_policy" "l1_infrastructure_ec2_policy" {
  name = "l1_infrastructure_ec2_policy"
  role = aws_iam_role.l1_infrastructure_ec2_policy.id

  policy = "${file("ec2-policy.json")}"
}

resource "aws_iam_role" "l1_infrastructure_ec2_policy" {
  name = "l1_infrastructure_ec2_policy"

  assume_role_policy = "${file("ec2-assume-policy.json")}"
}


#profile to connect IAM role to ec2
resource "aws_iam_instance_profile" "l1_infrastructure_ec2_profile" {
  name = "l1_infrastructure_ec2_profile"
  role = "${aws_iam_role.l1_infrastructure_ec2_policy.name}"
}


#Create securit group with firewall rules to have internet trafic on docker container
resource "aws_security_group" "l1-final-wordpress-sg" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  ingress {
    from_port   = 443 #https
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22 #ssh
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 80 #http
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080 #HTTP Alternate - open for jenkins to run script
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8000 #TCP
    to_port     = 8000
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from wordpress
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}


#key_pair to be able to connect to instance
resource "aws_key_pair" "l1_infrastructure_key" {
  key_name   = "l1_infrastructure_key"
  public_key = tls_private_key.l1_rsa.public_key_openssh
}


# RSA key of size 4096 bits
resource "tls_private_key" "l1_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


#creating a file on instance to store private_key
resource "local_file" "l1_infrastructure_key" {
  content  = tls_private_key.l1_rsa.private_key_pem
  filename = "tfkey"
}


resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  key_name = "l1_infrastructure_key"
  instance_type = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.l1_infrastructure_ec2_profile.name}"
  vpc_security_group_ids = [aws_security_group.l1-final-wordpress-sg.id]
  tags= {
    Name = var.tag_name
  }

  #USERDATA - pull container from dockerhub and run it
  user_data = file("ec2_script.sh")
}

# Create Elastic IP address
/*
resource "aws_eip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id
tags= {
    Name = "my_elastic_ip"
  }
}
*/