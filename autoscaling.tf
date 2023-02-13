#define autoscaling launch configuration
resource "aws_launch_configuration" "l1-launch-config" {
    name            = "l1-launch-config"
    image_id        = var.ami_id
    instance_type   = var.instance_type
    #spot_price      = "0.001" #(Optional; Default: On-demand price) The maximum price to use for reserving spot instances.
    key_name        = aws_key_pair.l1_infrastructure_key.key_name

  lifecycle {
    create_before_destroy = true
  }
}

#define autoscaling group
resource "aws_autoscaling_group" "l1-group-autoscaling" {
    name                      = "l1-group-autoscaling"
    vpc_zone_identifier       = ["subnet-033bbd9e872782bc2"] #(Optional) - The VPC zone identifier
    launch_configuration      = aws_launch_configuration.l1-launch-config.name # (Optional) Name of the launch configuration to use
    min_size                  = 2 #(Required) Minimum size of the Auto Scaling Group
    max_size                  = 4 #(Required) Maximum size of the Auto Scaling Group.
    health_check_grace_period = 100 #Time (in seconds) after instance comes into service before checking health.
    health_check_type         = "EC2" # (Optional) "EC2" or "ELB". Controls how health checking is done
    force_delete              = true #(Optional) Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate
    tag {
        key                   = "name"
        value                 = "l1_ec2_instance"
        propagate_at_launch   = true #(Required) Enables propagation of the tag to Amazon EC2 instances launched via this ASG
    }
}

/*
resource "aws_instance" "WordpressInstance" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  iam_instance_profile = "${aws_iam_instance_profile.l1_infrastructure_ec2_profile.name}"
  vpc_security_group_ids = [aws_security_group.l1-final-wordpress-sg.id]
  tags= {
    Name = var.tag_name
  }

  #USERDATA - pull container from dockerhub and run it
  user_data = file("ec2_script.sh")
}
*/