# Get the latest Ubuntu 24.04 LTS AMI in us-east-1
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Launch Template
resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my-launch-template-"
  key_name      = aws_key_pair.prod_key.key_name
  image_id      = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t2.small"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -euxo pipefail

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

docker pull r0hit45/containerized-app:${var.docker_image_version}

docker run -d \
  --name netflix-app \
  --restart unless-stopped \
  -p 80:80 \
  r0hit45/containerized-app:${var.docker_image_version}
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "prod-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Auto Scaling Group

resource "aws_autoscaling_group" "my_asg" {
  name                = "prod-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = module.vpc.public_subnet_ids

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = tostring(aws_launch_template.my_launch_template.latest_version)
  }

  target_group_arns = [
    aws_lb_target_group.app_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "prod-instance"
    propagate_at_launch = true
  }
}

//variable for docker image version
variable "docker_image_version" {
  description = "Version of the Docker image to be used in the application"
  type        = string
  default     = "6"
}

// Key Pair
resource "aws_key_pair" "prod_key" {
  key_name   = "prod-key"
  public_key = file("~/.ssh/prod-key.pub")
}