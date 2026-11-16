data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets = {
    a = { cidr = cidrsubnet(var.vpc_cidr, 8, 1), az = local.azs[0] }
    b = { cidr = cidrsubnet(var.vpc_cidr, 8, 2), az = local.azs[1] }
  }

  private_app_subnets = {
    a = { cidr = cidrsubnet(var.vpc_cidr, 8, 11), az = local.azs[0] }
    b = { cidr = cidrsubnet(var.vpc_cidr, 8, 12), az = local.azs[1] }
  }

  private_db_subnets = {
    a = { cidr = cidrsubnet(var.vpc_cidr, 8, 21), az = local.azs[0] }
    b = { cidr = cidrsubnet(var.vpc_cidr, 8, 22), az = local.azs[1] }
  }

  nat_keys = var.single_nat_gateway ? ["a"] : ["a", "b"]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-subnet-public-${each.key}"
    Tier = "public"
  }
}

resource "aws_subnet" "private_app" {
  for_each = local.private_app_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.name_prefix}-subnet-private-app-${each.key}"
    Tier = "private-app"
  }
}

resource "aws_subnet" "private_db" {
  for_each = local.private_db_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${local.name_prefix}-subnet-private-db-${each.key}"
    Tier = "private-db"
  }
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_keys)
  domain   = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip-nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.nat_keys)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${local.name_prefix}-nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.name_prefix}-rt-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private App Route Table(s) -> NAT Gateway
resource "aws_route_table" "private_app" {
  for_each = toset(local.nat_keys)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${local.name_prefix}-rt-private-app-${each.key}"
  }
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[var.single_nat_gateway ? "a" : each.key].id
}

# Private DB Route Table -> VPC local only (no internet route)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name_prefix}-rt-private-db"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}