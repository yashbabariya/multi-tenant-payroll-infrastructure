// VPC network
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_vpc


  enable_dns_support = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

// Subnets --> 2 public & 2 private
resource "aws_subnet" "public_subnet" {
  count                   = length(var.cidr_public_subnet)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.cidr_public_subnet, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.name}-Subnet-Public : ${count.index + 1}"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.availability_zone, count.index)

  tags = {
    Name = "${var.name}-Subnet-Private : ${count.index + 1}"
  }
  depends_on = [aws_vpc.vpc]
}

// Internet Gateway for public Subnet
resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-public_IGW"
  }
  depends_on = [aws_subnet.public_subnet]
}

// Nat-Gateway for private subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_subnet.private_subnet]

  tags = {
    Name = "Net-gateway"
  }
}

resource "aws_nat_gateway" "private_nat_gateway" {
  depends_on    = [aws_eip.nat_eip, aws_subnet.private_subnet]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.name}-Private-NatGateway"
  }
}

// Route-table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }

  tags = {
    Name = "${var.name}-public-route-table"
  }

  depends_on = [aws_subnet.public_subnet, aws_internet_gateway.public_internet_gateway]

}

resource "aws_route_table" "private_route_table" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_nat_gateway.private_nat_gateway]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_nat_gateway.id
  }

  tags = {
    Name = "${var.name}-private-route-table"
  }
}

// Route-table association
# Assocication in between InternetGateway and PublicSubnet
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.cidr_public_subnet)
  depends_on     = [aws_subnet.public_subnet, aws_route_table.public_route_table]
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Association in between NatGateway and PrivateSubnet
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.cidr_private_subnet)
  depends_on     = [aws_subnet.private_subnet, aws_nat_gateway.private_nat_gateway]
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
