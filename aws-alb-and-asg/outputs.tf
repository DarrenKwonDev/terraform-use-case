# output "public_ip" {
#     value = aws_instance.example.public_ip
# }

output "aws_vpc" {
    value = data.aws_vpc.default.id
}

output "aws_subnets" {
    value = data.aws_subnets.default.ids
}

output "alb_dns_name" {
    value = aws_lb.example.dns_name
}