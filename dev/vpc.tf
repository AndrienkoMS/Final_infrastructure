#create AWS VPC
resource "aws_vpc" "dev-vpc" {
    cidr_block = "172.25.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "dev-vpc"
    }
  
}
#public subnets for Elastic Load Balancer
resource "aws_subnet" "devvpc-public-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "172.25.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1a"
    tags = {
        Name ="devvpc-public-1"
    }
}

resource "aws_subnet" "devvpc-public-2" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "172.25.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1b"
    tags = {
        Name ="devvpc-public-2"
    }
}

resource "aws_route_table" "dev-rt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dev-rt"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id
}

#create an association between a route table and a subnet 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.devvpc-public-1.id
  route_table_id = aws_route_table.dev-rt.id
}

#create an association between a route table and a subnet 
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.devvpc-public-2.id
  route_table_id = aws_route_table.dev-rt.id
}
