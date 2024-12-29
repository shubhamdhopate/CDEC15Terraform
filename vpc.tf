resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_cidr_block)
  cidr_block              = element(var.public_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.private_cidr_block)
  cidr_block        = element(var.private_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mainigw"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = "private-route-table"
  }
}


resource "aws_route_table_association" "publicass" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "privateass" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.privatert.id
  depends_on     = [aws_nat_gateway.nat]
}

resource "aws_eip" "eip_nat" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat-gateway"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.privatert.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
  depends_on             = [aws_route_table.privatert]
}