resource "aws_db_subnet_group" "db-sng-k8s" {
  name = "vpc-k8s"
  subnet_ids = [ aws_subnet.sn-k8s-1.id, aws_subnet.sn-k8s-2.id, aws_subnet.sn-k8s-3.id ]

  tags = {
    "Name" = "vpc-k8s"
  }

  depends_on = [ aws_subnet.sn-k8s-1, aws_subnet.sn-k8s-2, aws_subnet.sn-k8s-3 ]
}

resource "aws_db_instance" "db-k8s" {
  engine = "mysql"
  engine_version = "5.7.31"

  identifier = "k8s"
  username = "root"
  password = var.rds_password

  instance_class = "db.t3.small"

  storage_type = "gp2"
  allocated_storage = 20
  max_allocated_storage = 100

  db_subnet_group_name = aws_db_subnet_group.db-sng-k8s.name
  publicly_accessible = true
  vpc_security_group_ids = [ aws_default_security_group.sg-vpc-k8s.id ]

  skip_final_snapshot = true

  depends_on = [ aws_db_subnet_group.db-sng-k8s ]
}