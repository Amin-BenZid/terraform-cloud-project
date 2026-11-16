locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# --- Security Groups ---

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-sg-alb"
  description = "Allow HTTP/HTTPS from Internet to ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-sg-alb"
  }
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-sg-app"
  description = "Allow web traffic only from ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-sg-app"
  }
}

resource "aws_security_group" "db" {
  name        = "${local.name_prefix}-sg-db"
  description = "Allow DB traffic only from App Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.name_prefix}-sg-db"
  }
}

# --- ALB Rules ---

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each = toset(var.allowed_http_cidrs)

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from Internet"
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  for_each = toset(var.allowed_http_cidrs)

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS from Internet"
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Forward traffic to application instances"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
}

# --- App Rules ---

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow app traffic only from ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow DB queries from app to RDS"
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "Allow outbound HTTPS for package updates and SSM"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_http_out" {
  security_group_id = aws_security_group.app.id
  description       = "Allow outbound HTTP for yum repositories via NAT"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# --- DB Rules ---

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Allow DB traffic only from application instances"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
}

# --- IAM Role & Instance Profile (Least Privilege) ---

data "aws_iam_instance_profile" "existing" {
  count = var.use_existing_lab_role ? 1 : 0
  name  = var.existing_instance_profile_name
}

resource "aws_iam_role" "ec2" {
  count = var.use_existing_lab_role ? 0 : 1
  name  = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.use_existing_lab_role ? 0 : 1
  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "s3_least_privilege" {
  count = (!var.use_existing_lab_role && var.storage_bucket_arn != "") ? 1 : 0
  name  = "${local.name_prefix}-ec2-s3-policy"
  role  = aws_iam_role.ec2[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [var.storage_bucket_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = ["${var.storage_bucket_arn}/*"]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.use_existing_lab_role ? 0 : 1
  name  = "${local.name_prefix}-ec2-profile"
  role  = aws_iam_role.ec2[0].name
}