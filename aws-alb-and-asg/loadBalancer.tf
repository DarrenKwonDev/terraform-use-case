# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# LB -> 리스너, 리스닝 룰, 대상 그룹(target groups) 3가지 필요함.
resource "aws_lb" "example" {
    name = "terraform-asg-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [ aws_security_group.alb.id ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.arn
    port = 80
    protocol = "HTTP"

    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#default_action
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

// ALB에도 보안 그룹을 설정해야 함
resource "aws_security_group" "alb" {
    name = "terraform-example-alb"

    # inbound 80포트로 오는 모든 트래픽 허용
    ingress {
        from_port = 80 
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0 
        to_port = 0 
        protocol = "-1" //  If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0. 
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200" # 상태 코드 200 받아야 성공함
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn # The ARN of the listener to which to attach the rule.
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        # Specify only if type is forward and you want to route to a single target group.
        target_group_arn = aws_lb_target_group.asg.arn
    }
}