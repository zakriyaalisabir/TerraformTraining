# asg launch template
resource "aws_launch_template" "test-template" {
  name_prefix   = "test-template"
  image_id      = "${lookup(var.AMI, var.AWS_REGION)}"
  key_name = "kk_key"
  instance_type = "t2.micro"
  security_group_names = ["${aws_security_group.sg-asg.name}"]
  user_data = "${file("userdata.sh")}"
}

# asg definition
resource "aws_autoscaling_group" "test-asg" {
  name = "test-asg"
  vpc_zone_identifier = ["${aws_subnet.prod-subnet-public-1.id}","${aws_subnet.prod-subnet-public-2.id}"]

  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  health_check_grace_period = 300
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.alb.name}"]
  force_delete = true

  launch_template {
    id      = "${aws_launch_template.test-template.id}"
    version = "$Latest"
  }

  tags = {
    Name               = "test-asg"
    propagate_at_launch = true
  }
}

# Scale up policy
resource "aws_autoscaling_policy" "test_autoscaling_up_policy" {
  name = "test_autoscaling_up_policy"
  autoscaling_group_name = "${aws_autoscaling_group.test-asg.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
  policy_type = "SimpleScaling"
}

# Scale up policy alarm
resource "aws_cloudwatch_metric_alarm" "asg-alarm-up" {
  alarm_name = "asg-alarm-up"
  alarm_description = "asg-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 20

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.test-asg.name}"
  }

  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.test_autoscaling_up_policy.arn}"]
}

# Scale down policy
resource "aws_autoscaling_policy" "test_autoscaling_down_policy" {
  name = "test_autoscaling_down_policy"
  autoscaling_group_name = "${aws_autoscaling_group.test-asg.name}"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = 300
  policy_type = "SimpleScaling"
}

# Scale down policy alarm
resource "aws_cloudwatch_metric_alarm" "asg-alarm-down" {
  alarm_name = "asg-alarm-down"
  alarm_description = "asg-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 5

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.test-asg.name}"
  }

  actions_enabled = true
  alarm_actions = ["${aws_autoscaling_policy.test_autoscaling_down_policy.arn}"]
}