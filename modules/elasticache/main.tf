resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "this" {
  name_prefix = "${var.cluster_id}-elasticache-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    iterator = cidr
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [cidr.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    iterator = sg
    content {
      from_port       = var.port
      to_port         = var.port
      protocol        = "tcp"
      security_groups = [sg.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_id}-elasticache-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_parameter_group" "this" {
  family = var.parameter_group_family
  name   = "${var.cluster_id}-parameter-group"

  dynamic "parameter" {
    for_each = var.engine == "redis" ? [1] : []
    content {
      name  = "maxmemory-policy"
      value = "allkeys-lru"
    }
  }

  tags = var.tags
}

resource "aws_elasticache_replication_group" "redis" {
  count = var.engine == "redis" ? 1 : 0

  replication_group_id = var.cluster_id
  description          = "Redis cluster for ${var.cluster_id}"

  node_type = var.node_type
  port      = var.port

  num_cache_clusters         = var.num_cache_nodes
  automatic_failover_enabled = var.num_cache_nodes > 1

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  engine               = "redis"
  engine_version       = var.engine_version
  parameter_group_name = aws_elasticache_parameter_group.this.name

  maintenance_window = var.maintenance_window
  snapshot_window    = var.snapshot_window

  tags = var.tags
}

resource "aws_elasticache_cluster" "memcached" {
  count = var.engine == "memcached" ? 1 : 0

  cluster_id           = var.cluster_id
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.this.name
  port                 = var.port

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  maintenance_window = var.maintenance_window

  tags = var.tags
}
