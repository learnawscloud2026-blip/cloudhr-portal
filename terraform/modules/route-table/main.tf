resource "aws_route_table" "public" {

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-rt"
    }
  )
}

resource "aws_route" "public_internet" {

  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = var.internet_gateway_id
}

resource "aws_route_table" "private" {

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-rt"
    }
  )
}

resource "aws_route" "private_nat" {

  route_table_id = aws_route_table.private.id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.nat_gateway_id
}

resource "aws_route_table" "database" {

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-database-rt"
    }
  )
}

resource "aws_route_table_association" "public_a" {

  subnet_id = var.subnet_ids["public-a"]

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {

  subnet_id = var.subnet_ids["public-b"]

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app_a" {

  subnet_id = var.subnet_ids["private-app-a"]

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app_b" {

  subnet_id = var.subnet_ids["private-app-b"]

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database_a" {

  subnet_id = var.subnet_ids["private-db-a"]

  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database_b" {

  subnet_id = var.subnet_ids["private-db-b"]

  route_table_id = aws_route_table.database.id
}

