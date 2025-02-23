resource "aws_vpc" "main" {
  cidr_block           = var.vpc_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tech-challenge-VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Subnets",
    Network = "Public"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat_eip_1" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_01_block
  availability_zone       = data.aws_availability_zones.available.names[0]  
  map_public_ip_on_launch = true

  tags = {
    Name = "tech-challenge-PublicSubnet01"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "tech-challenge-NatGatewayAZ1"
  }

  depends_on = [aws_internet_gateway.main, aws_subnet.public_1, aws_eip.nat_eip_1]
}

resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "Private Subnet AZ1",
    Network = "Private01"
  }
  
  depends_on = [aws_nat_gateway.nat_1]
}

resource "aws_eip" "nat_eip_2" {
  domain   = "vpc"
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_02_block
  availability_zone       = data.aws_availability_zones.available.names[1]  
  map_public_ip_on_launch = true

  tags = {
    Name = "tech-challenge-PublicSubnet02"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "tech-challenge-NatGatewayAZ2"
  }

  depends_on = [aws_internet_gateway.main, aws_subnet.public_2, aws_eip.nat_eip_2]
}

resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "Private Subnet AZ2",
    Network = "Private02"
  }
  
  depends_on = [aws_nat_gateway.nat_2]
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_01_block
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "tech-challenge-PrivateSubnet01"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_02_block
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "tech-challenge-PrivateSubnet02"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_az1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_az2.id
}