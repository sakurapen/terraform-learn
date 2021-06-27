resource "aws_elasticache_subnet_group" "cache-sng-k8s" {
  name = "vpc-k8s"
  subnet_ids = [ aws_subnet.sn-k8s-1.id, aws_subnet.sn-k8s-2.id, aws_subnet.sn-k8s-3.id ]

  depends_on = [ aws_subnet.sn-k8s-1, aws_subnet.sn-k8s-2, aws_subnet.sn-k8s-3 ]
}

resource "aws_elasticache_cluster" "cache-k8s" {
  engine = "redis"
  engine_version = "5.0.6"

  cluster_id = "k8s"
  port = 6379
  parameter_group_name = "default.redis5.0"
  node_type = "cache.t3.small"
  num_cache_nodes = 1

  subnet_group_name = "vpc-k8s"
  security_group_ids = [ aws_default_security_group.sg-vpc-k8s.id ]

  snapshot_retention_limit = 0

  depends_on = [ aws_elasticache_subnet_group.cache-sng-k8s ]
}