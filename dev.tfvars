#main.tf
instance_type               = "t2.micro"
db_instance_class           = "db.t2.micro"
db_subnet_group             = "dev_wp_subnet_group"
iam_role_policy_name        = "dev_infrastructure_ec2_policy"
iam_instance_profile_name   = "dev_infrastructure_ec2_profil"
#elb.tf
elb_name                        = "dev-elb"
l1-elb-sg_name                  = "dev-elb-sg"
l1-instance-sg_name             = "dev-instance-sg"
#vpc.tf
l1-vpc_name                 = "dev-vpc"
l1vpc-public-1_name         = "dev-vpc-public-1"
l1vpc-public-2_name         = "dev-vpc-public-2"
l1-rt_name                  = "dev-rt"
#autoscaling.tf
l1-group-autoscaling_name       = "dev-group-autoscaling"
l1-group-autoscaling_min_size   = 2
l1-cpu-policy_cooldown          = 35
l1-cpu-alarm_name               = "dev-cpu-alarm"
l1-cpu-policy-scaledown_name    = "dev-cpu-policy-scaledown"
l1-cpu-alarm-scaledown_name     = "dev-cpu-alarm-scaledown"