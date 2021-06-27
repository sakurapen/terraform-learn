resource "aws_efs_file_system" "k8s-data" {
  encrypted = false
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

  tags = {
    "Name" = "k8s-data"
  }
}

resource "aws_efs_mount_target" "k8s-data-1a" {
  file_system_id = aws_efs_file_system.k8s-data.id
  subnet_id = aws_subnet.sn-k8s-1.id

  depends_on = [ aws_efs_file_system.k8s-data, aws_subnet.sn-k8s-1 ]
}

resource "aws_efs_mount_target" "k8s-data-1b" {
  file_system_id = aws_efs_file_system.k8s-data.id
  subnet_id = aws_subnet.sn-k8s-2.id

  depends_on = [ aws_efs_file_system.k8s-data, aws_subnet.sn-k8s-2 ]
}

resource "aws_efs_mount_target" "k8s-data-1c" {
  file_system_id = aws_efs_file_system.k8s-data.id
  subnet_id = aws_subnet.sn-k8s-3.id

  depends_on = [ aws_efs_file_system.k8s-data, aws_subnet.sn-k8s-3 ]
}
