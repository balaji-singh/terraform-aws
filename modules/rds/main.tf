data "aws_ssm_parameter" "username" {
  name = var.username_ssm_parameter
}

data "aws_ssm_parameter" "password" {
  name = var.password_ssm_parameter
}

locals {
  tags = merge(
    var.tags,
    var.default_tags,
    {
      "terraform-module"    = "rds"
      "terraform-workspace" = terraform.workspace
    },
  )
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "${var.identifier}-subnet-group"
    },
    local.tags
  )
}

resource "aws_security_group" "this" {
  name_prefix = "${var.identifier}-rds-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.identifier}-rds-sg"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted

  username = data.aws_ssm_parameter.username.value
  password = data.aws_ssm_parameter.password.value
  port     = var.port

  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible     = var.publicly_accessible
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"

  tags = merge(
    {
      Name = var.identifier
    },
    local.tags
  )
}
