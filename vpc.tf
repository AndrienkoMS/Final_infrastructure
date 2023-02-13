#create AWS VPC
resource "aws_vpc" "l1-vpc" {
    cidr_block = "172.25.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_classiclink = false
    tags {
        Name = "l1-vps"
    }
  
}
#public subnets for Elastic Load Balancer
resource "aws_subnet" "l1vpc-public-1" {
    vpc_id = awc_vpc.l1-vpc.id
    cidr_block = "172.25.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1b"
    tags = {
        Name ="l1vpc-public-1"
    }
}

resource "aws_subnet" "l1vpc-public-2" {
    vpc_id = awc_vpc.l1-vpc.id
    cidr_block = "172.25.3.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1c"
    tags = {
        Name ="l1vpc-public-2"
    }
}