provider "aws" {
  region = var.aws_region
}

locals {
  wsp = terraform.workspace
  # ${local.wsp}  - doesn't work
}

#Create RDS MySQL database to store wordpress data
resource "aws_db_instance" "default" {
  vpc_security_group_ids = [aws_security_group.l1-elb-sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_sg.id
  availability_zone = "us-west-1a"
  identifier        = "wordpressdb"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t2.micro"
  name              = var.dbname
  username          = var.dbuser
  password          = var.dbpassword
  allocated_storage = 5
  skip_final_snapshot = true
  publicly_accessible = true
}

resource "aws_db_subnet_group" "db_sg" {
  name       = "wp_subnet_group"
  subnet_ids = [aws_subnet.l1vpc-public-1.id, aws_subnet.l1vpc-public-2.id]

  tags = {
    Name = "My DB subnet groups"
  }
}


#IAM role to attach to ec2 to connect to DB
resource "aws_iam_role_policy" "l1_infrastructure_ec2_policy" {
  name = "l1_infrastructure_ec2_policy"
  role = aws_iam_role.l1_infrastructure_ec2_policy.id

  policy = "${file("modules/ec2-policy.json")}"
}

resource "aws_iam_role" "l1_infrastructure_ec2_policy" {
  name = "l1_infrastructure_ec2_policy"

  assume_role_policy = "${file("modules/ec2-assume-policy.json")}"
}


#profile to connect IAM role to ec2
resource "aws_iam_instance_profile" "l1_infrastructure_ec2_profile" {
  name = "l1_infrastructure_ec2_profile"
  role = "${aws_iam_role.l1_infrastructure_ec2_policy.name}"
}

/*
#Create securit group with firewall rules to have internet trafic on docker container
resource "aws_security_group" "l1-final-wordpress-sg" {
  name        = "l1-l1-final-wordpress-sg"
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
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ingress {
  #  from_port   = 0 #TCP
  #  to_port     = 0
  #  protocol    = "-1"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

 # outbound from wordpress
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "l1-l1-final-wordpress-sg"
  }
}
*/

#key_pair to be able to connect to instance
resource "aws_key_pair" "l1_infrastructure_key" {
  key_name   = var.key_name
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

/*
resource "aws_instance" "WordpressInstance" {
  ami                     = var.ami_id
  key_name                = var.key_name  
  instance_type           = var.instance_type
  iam_instance_profile    = "${aws_iam_instance_profile.l1_infrastructure_ec2_profile.name}"
  #vpc_security_group_ids  = [aws_security_group.l1-elb-sg.id]
  vpc_security_group_ids  = [aws_security_group.l1-final-wordpress-sg.id]
  tags= {
    Name = "WordpressInstance-${var.build}"
  }

  #USERDATA - pull container from dockerhub and run it
  user_data = file("ec2_script.sh")
  depends_on = [
    aws_db_instance.default
  ]
}
*/