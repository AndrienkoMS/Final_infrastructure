#main
instance_type               = "t2.small"
db_instance_class           = "db.t2.small"
db_subnet_group             = "prod_wp_subnet_group"
iam_role_policy_name        = "prod_infrastructure_ec2_policy"
iam_instance_profile_name   = "prod_infrastructure_ec2_profil"
key_name                    = "prod_infrastructure_key"
db_identifier               = "prodwordpressdb"
#elb.tf
elb_name                        = "prod-elb"
l1-elb-sg_name                  = "prod-elb-sg"
l1-instance-sg_name             = "prod-instance-sg"
#vpc.tf
l1-vpc_name                 = "prod-vpc"
l1vpc-public-1_name         = "prod-vpc-public-1"
l1vpc-public-2_name         = "prod-vpc-public-2"
l1-rt_name                  = "prod-rt"
#autoscaling.tf
l1-group-autoscaling_name       = "prod-group-autoscaling"
l1-group-autoscaling_min_size   = 1
l1-cpu-policy_cooldown          = 50
l1-cpu-alarm_name               = "prod-cpu-alarm"
l1-cpu-policy-scaledown_name    = "prod-cpu-policy-scaledown"
l1-cpu-alarm-scaledown_name     = "prod-cpu-alarm-scaledown"