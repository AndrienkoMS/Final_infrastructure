#define autoscaling launch configuration
resource "aws_launch_configuration" "as_conf" {
    name            = "l1-launch-config"
    image_id        = var.ami_id
    instance_type   = var.instance_type
    #spot_price      = "0.001" #(Optional; Default: On-demand price) The maximum price to use for reserving spot instances.
    key_name        = aws_key_pair.l1_infrastructure_key.key_name

  lifecycle {
    create_before_destroy = true
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