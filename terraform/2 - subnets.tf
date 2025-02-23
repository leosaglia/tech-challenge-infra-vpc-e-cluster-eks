resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_blocks[count.index]
  availability_zone       = locals.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "tech-challenge-PublicSubnet${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_blocks[count.index]
  availability_zone       = locals.availability_zones[count.index]

  tags = {
    Name = "tech-challenge-PrivateSubnet${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}