
resource "aws_vpc" "demo-vpc" {
  cidr_block = "168.24.0.0/16"
}

#get AZs in the current region
data "aws_availability_zones" "available" {
}

#Create 2 private subnets and each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.demo-vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.demo-vpc.id
}

#Create 2 public subnets and each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.demo-vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.demo-vpc.id
  map_public_ip_on_launch = true
}

#Internet Gateway for the public subnet
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
}

#Route the public subnet traffic through the internet gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.demo-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demo-igw.id
}

#associate the created route tables to the private subnets.
resource "aws_route_table_association" "rta-private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.rt-private.*.id, count.index)
}