resource "aws_nat_gateway" "this" {

  allocation_id = var.allocation_id

  subnet_id = var.public_subnet_id

  connectivity_type = "public"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-nat-gateway"
    }
  )

  depends_on = [
    var.allocation_id
  ]

}