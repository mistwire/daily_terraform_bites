locals {
  east_1_base = "10.0.0.0/16"
  west_1_base = "10.1.0.0/16"
}

# East cost VPC
resource "aws_vpc" "east_1" {
  provider   = aws.us-east-1
  cidr_block = local.east_1_base

  tags = {
    Name = "first"
  }
}

resource "aws_subnet" "east_1_subnets" {
  count      = 4
  provider   = aws.us-east-1
  vpc_id     = aws_vpc.east_1.id
  cidr_block = cidrsubnet(local.east_1_base, 8, count.index)

  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "east_gw" {
  provider = aws.us-east-1
  vpc_id   = aws_vpc.east_1.id
  tags = {
    Name = "Eastern VPC IG"
  }
}

resource "aws_route_table" "second_rt_east" {
  provider = aws.us-east-1
  vpc_id   = aws_vpc.east_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.east_gw.id
  }
}

resource "aws_route_table_association" "public_east" {
  provider       = aws.us-east-1
  count          = 2
  subnet_id      = element(aws_subnet.east_1_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt_east.id
}

# West coast VPC
resource "aws_vpc" "west_1" {
  provider   = aws.us-west-1
  cidr_block = local.west_1_base

  tags = {
    Name = "second"
  }
}

resource "aws_subnet" "west_1_subnets" {
  count      = 4
  provider   = aws.us-west-1
  vpc_id     = aws_vpc.west_1.id
  cidr_block = cidrsubnet(local.west_1_base, 8, count.index)

  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "west_gw" {
  provider = aws.us-west-1
  vpc_id   = aws_vpc.west_1.id
  tags = {
    Name = "Western VPC IG"
  }
}

resource "aws_route_table" "second_rt_west" {
  provider = aws.us-west-1
  vpc_id   = aws_vpc.west_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.west_gw.id
  }
}

resource "aws_route_table_association" "public_west" {
  provider       = aws.us-west-1
  count          = 2
  subnet_id      = element(aws_subnet.west_1_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt_west.id
}

# Establish VPC peering between east & west
resource "aws_vpc_peering_connection" "peer_origin" {
  provider    = aws.us-east-1
  vpc_id      = aws_vpc.east_1.id
  peer_vpc_id = aws_vpc.west_1.id
  peer_region = "us-west-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = aws.us-west-1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_origin.id
  auto_accept               = true
}

resource "aws_security_group" "allow_ssh_east" {
  provider = aws.us-east-1
  vpc_id   = aws_vpc.east_1.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh_west" {
  provider = aws.us-west-1
  vpc_id   = aws_vpc.west_1.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# route tables to allow communication between peered VPCs
resource "aws_route" "east_to_west" {
  provider                  = aws.us-east-1
  route_table_id            = aws_route_table.second_rt_east.id
  destination_cidr_block    = local.west_1_base
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_origin.id
}

resource "aws_route" "west_to_east" {
  provider                  = aws.us-west-1
  route_table_id            = aws_route_table.second_rt_west.id
  destination_cidr_block    = local.east_1_base
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_origin.id
}
