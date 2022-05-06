resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # private ip 대역대

  tags = {
    "Name" = "terraform-example" # vpc의 이름
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"     # public subnet의 대역대
  availability_zone = "ap-northeast-2a" # public subnet의 az

  tags = {
    "Name" = "terraform-example-public-subnet" # public subnet의 이름
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"    # private subnet의 대역대
  availability_zone = "ap-northeast-2c" # public subnet의 az

  tags = {
    "Name" = "terraform-example-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "terraform-example-igw"
  }
}

resource "aws_eip" "nat_ip" {
  vpc = true # if the EIP is in a VPC or not.

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_ip.id

  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "terraform-NAT-GW"
  }
}

# rt
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  # inner rule. coupling 측면에서는 inner rule보다 aws_route로 빼는게 나음
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "terraform-example-rtb-public"
  }
}

# rt와 subnet의 연결
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "route_table_association_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "terraform-example-rtb-private"
  }
}

resource "aws_route_table_association" "route_table_association_private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# rt inner rule이 아니라 밖으로 빼서 정의할 수도 있음. 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
