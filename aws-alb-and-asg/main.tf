provider "aws" {
    region = "us-east-2"
}


data "aws_vpc" "default" {
    default = true
}

# aws_subnet_ids는 deprecated
data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "example" {
#     ami = "ami-0c55b159cbfafe1f0"
#     instance_type = "t2.micro"
#     vpc_security_group_ids = [ aws_security_group.instance.id ]

#     user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello" > index.html
#                 nohup busybox httpd -f -p ${var.server_port} &
#                 EOF

#     tags = {
#         "Name" = "terraform-example"
#     }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        from_port = var.server_port 
        to_port = var.server_port 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
# ASG를 만드는 시작 구성. Provides a resource to create a new launch configuration, used for autoscaling groups.
resource "aws_launch_configuration" "example" {
    image_id = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.instance.id ]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
    
    lifecycle {
        create_before_destroy = true
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    target_group_arns = [ aws_lb_target_group.asg.arn ]
    health_check_type = "ELB" # "EC2" or "ELB". Controls how health checking is done.

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

