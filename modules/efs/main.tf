# Security Group for EFS Access from EC2 App Instances
resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs-sg"
  description = "Security group for Elastic File System"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.project_name}-efs-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "efs_from_app" {
  security_group_id            = aws_security_group.efs.id
  description                  = "Allow NFS traffic from App SG"
  referenced_security_group_id = var.app_security_group_id
  from_port                    = 2049
  ip_protocol                  = "tcp"
  to_port                      = 2049
}

# EFS File System
resource "aws_efs_file_system" "main" {
  creation_token   = "${var.project_name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  tags = merge(var.tags, { Name = "${var.project_name}-efs" })
}

# Mount Targets in Private Subnets
resource "aws_efs_mount_target" "private" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}