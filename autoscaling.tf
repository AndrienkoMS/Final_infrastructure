resource "aws_launch_configuration" "l1-launch-config" {
    name            = "l1-launch-config"
    image_id        = var.ami_id
    instance_type   = var.instance_type
    #spot_price      = "0.001" #(Optional; Default: On-demand price) The maximum price to use for reserving spot instances.
    #key_name        = aws_key_pair.l1_infrastructure_key.key_name
    key_name        = aws_key_pair.autoscaling_key.name
    
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "autoscaling_key" {
    key_name = "autoscaling_key"
    public_key = file("autoscaling_key")
}

resource "aws_autoscaling_group" "l1-group-autoscaling" {
    name                      = "l1-group-autoscaling"
    vpc_zone_identifier       = ["subnet-033bbd9e872782bc2","subnet-0aaaa3f6dadcf369e"]                    #(Optional) - The VPC zone identifier
    #vpc_zone_identifier       = [aws_security_group.l1-final-wordpress-sg.id]
    launch_configuration      = aws_launch_configuration.l1-launch-config.name  #(Optional) Name of the launch configuration to use
    min_size                  = 1                                               #(Required) Minimum size of the Auto Scaling Group
    max_size                  = 4                                               #(Required) Maximum size of the Auto Scaling Group.
    health_check_grace_period = 60                                              #Time (in seconds) after instance comes into service before checking health.
    health_check_type         = "EC2"                                           #(Optional) "EC2" or "ELB". Controls how health checking is done
    force_delete              = true            #(Optional) Allows deleting the Auto Scaling Group without waiting for all instances in the pool to terminate
    tag {
        key                   = "name"
        value                 = "l1_ec2_instance"
        propagate_at_launch   = true            #(Required) Enables propagation of the tag to Amazon EC2 instances launched via this ASG
    }
}

resource "aws_autoscaling_policy" "l1-cpu-policy" {
    name                   = "l1-cpu-policy"
    scaling_adjustment     = 1                  #(Optional) Number of instances by which to scale
    autoscaling_group_name = aws_autoscaling_group.l1-group-autoscaling.name
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 60                 #(Optional) Amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start
    policy_type = "SimpleScaling"   #(Optional) Policy type, either "SimpleScaling", "StepScaling", "TargetTrackingScaling", or "PredictiveScaling". If this value isn't provided, AWS will default to "SimpleScaling."
}

#define cloud watch monitoring
resource "aws_cloudwatch_metric_alarm" "l1-cpu-alarm" {
    alarm_name          = "l1-cpu-alarm"
    alarm_description   = "alarm once cpu usage increases"
    comparison_operator = "GreaterThanOrEqualToThreshold"   #(Required) The arithmetic operation to use when comparing the specified Statistic and Threshold
    evaluation_periods  = "2"                               #(Required) The number of periods over which data is compared to the specified threshold
    metric_name         = "CPUUtilization"                  #(Optional) The name for the alarm's associated metric
    namespace           = "AWS/EC2"
    period              = "120"                             #(Required) The period in seconds over which the specified stat is applied
    statistic           = "Average"
    threshold           = "30"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.l1-group-autoscaling.name
    }

    alarm_actions     = [aws_autoscaling_policy.l1-cpu-policy.arn] #(Optional) The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN).
}

#define descaling policy
resource "aws_autoscaling_policy" "l1-cpu-policy-scaledown" {
    name                   = "l1-cpu-policy-scaledown"
    scaling_adjustment     = -1                 #(Optional) Number of instances by which to scale
    autoscaling_group_name = aws_autoscaling_group.l1-group-autoscaling.name
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 60                 #(Optional) Amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start
    policy_type = "SimpleScaling"   #(Optional) Policy type, either "SimpleScaling", "StepScaling", "TargetTrackingScaling", or "PredictiveScaling". If this value isn't provided, AWS will default to "SimpleScaling."
}

#define descaling cloud watch
resource "aws_cloudwatch_metric_alarm" "l1-cpu-alarm-scaledown" {
    alarm_name          = "l1-cpu-alarm-scaledown"
    alarm_description   = "alarm once cpu usage decreases"
    comparison_operator = "LessThanOrEqualToThreshold"      #(Required) The arithmetic operation to use when comparing the specified Statistic and Threshold
    evaluation_periods  = "2"                               #(Required) The number of periods over which data is compared to the specified threshold
    metric_name         = "CPUUtilization"                  #(Optional) The name for the alarm's associated metric
    namespace           = "AWS/EC2"
    period              = "120"                             #(Required) The period in seconds over which the specified stat is applied
    statistic           = "Average"
    threshold           = "10"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.l1-group-autoscaling.name
    }

    alarm_actions     = [aws_autoscaling_policy.l1-cpu-policy-scaledown.arn] #(Optional) The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN).
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