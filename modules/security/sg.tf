# ==========================================
# 1. LOAD BALANCER SECURITY GROUP (PUBLIC)
# ==========================================
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for public facing Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.project_name}-alb-sg" })
}

# Inbound HTTP from Anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTP web traffic"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Inbound HTTPS from Anywhere
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow inbound HTTPS web traffic"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Outbound Traffic from ALB to App Instances
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow outbound traffic from ALB to App SG"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.app_port
  ip_protocol                  = "tcp"
  to_port                      = var.app_port
}

# ==========================================
# 2. APPLICATION SECURITY GROUP (PRIVATE)
# ==========================================
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for EC2 application instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.project_name}-app-sg" })
}

# Inbound Traffic ONLY from ALB SG
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow inbound app traffic from ALB SG only"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.app_port
  ip_protocol                  = "tcp"
  to_port                      = var.app_port
}

# Outbound Traffic to Database SG
resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow outbound traffic to Database SG"
  referenced_security_group_id = aws_security_group.db.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}

# Outbound Traffic to Internet via NAT (for updates / external APIs)
resource "aws_vpc_security_group_egress_rule" "app_to_internet" {
  security_group_id = aws_security_group.app.id
  description       = "Allow outbound HTTPS for software updates"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# ==========================================
# 3. DATABASE SECURITY GROUP (PRIVATE)
# ==========================================
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for RDS database instances"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.project_name}-db-sg" })
}

# Inbound Traffic ONLY from App SG
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Allow inbound DB access from App SG only"
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}