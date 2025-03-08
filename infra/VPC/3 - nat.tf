resource "aws_eip" "nat_eip" {
  count    = length(var.public_subnet_blocks)
  domain   = "vpc"
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat" {
  count        = length(var.public_subnet_blocks)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "tech-challenge-NatGatewayAZ${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main, aws_subnet.public, aws_eip.nat_eip]
}