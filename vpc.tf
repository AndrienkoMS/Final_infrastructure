#create AWS VPC
resource "aws_vpc" "l1-vpc" {
    cidr_block = "172.25.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "l1-vps"
    }
  
}
#public subnets for Elastic Load Balancer
resource "aws_subnet" "l1vpc-public-1" {
    vpc_id = aws_vpc.l1-vpc.id
    cidr_block = "172.25.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1a"
    tags = {
        Name ="l1vpc-public-1"
    }
}

resource "aws_subnet" "l1vpc-public-2" {
    vpc_id = aws_vpc.l1-vpc.id
    cidr_block = "172.25.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1b"
    tags = {
        Name ="l1vpc-public-2"
    }
}

resource "aws_route_table" "l1-rt" {
  vpc_id = aws_vpc.l1-vpc.id

  route {
    cidr_block = ""0.0.0.0/0""
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "l1-rt"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.l1-vpc.id
}

/*
#create an association between a route table and a subnet 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.l1vpc-public-1.id
  route_table_id = "rtb-030451465d369c659"
}
*/