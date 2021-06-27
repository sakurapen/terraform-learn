output "rds_connection_string" {
  value = aws_db_instance.db-k8s.endpoint
}

output "elasticache_connection_string" {
  value = aws_elasticache_cluster.cache-k8s.cache_nodes
}

output "efs-k8s-data_connection_string" {
  value = aws_efs_file_system.k8s-data.dns_name
}

output "efs-k8s-etcd_connection_string" {
  value = aws_efs_file_system.k8s-etcd.dns_name
}

output "efs-k8s-media_connection_string" {
  value = aws_efs_file_system.k8s-media.dns_name
}

output "k8s-master-01_connection_string" {
  value = aws_instance.k8s-master-01.public_ip
}

output "k8s-worker-01_connection_string" {
  value = aws_instance.k8s-worker-01.public_ip
}

output "k8s-worker-02_connection_string" {
  value = aws_instance.k8s-worker-02.public_ip
}