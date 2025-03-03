resource "aws_route_table" "private" {
  count = length(var.private_subnet_blocks)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "Private Subnet AZ${count.index + 1}",
    Network = "Private${count.index + 1}"
  }
  
  depends_on = [aws_nat_gateway.nat]
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

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
