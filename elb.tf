#AWS ELB config
resource "aws_elb" "l1-elb" {
    name               = var.elb_name
    subnets = [aws_subnet.l1vpc-public-1.id,aws_subnet.l1vpc-public-2.id]
    security_groups = [aws_security_group.l1-elb-sg.id]
    internal = true
  #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.elb_name

  }
}

#security group for AWS ELB
resource "aws_security_group" "l1-elb-sg" {
    vpc_id = aws_vpc.l1-vpc.id
    name = var.l1-elb-sg_name
    description = "security group for ELB"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.l1-elb-sg_name
    }
}

#security group for instances
resource "aws_security_group" "l1-instance-sg" {
    vpc_id = aws_vpc.l1-vpc.id
    name = var.l1-instance-sg_name
    description = "security group for instances"

    ingress {
        from_port = 22
        to_port = 80
        protocol = "tcp"
        #security_groups = [aws_security_group.l1-elb-sg.id]
        cidr_blocks = ["0.0.0.0/0"]
    }
/*
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
*/
    ingress {
        from_port   = 0 
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.l1-instance-sg_name
    }
}