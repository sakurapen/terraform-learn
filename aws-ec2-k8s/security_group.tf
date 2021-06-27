resource "aws_security_group" "k8s-master" {
  name = "k8s-master"
  description = "k8s master nodes security group"
  vpc_id = aws_vpc.vpc-k8s.id

  ingress = [ {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  }, {
    description = "Allow kubectl"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  }, {
    description = "Allow VPC"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "172.16.0.0/16" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  } ]

  egress = [ {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    description = null
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  } ]

  tags = {
    "Name" = "k8s-master"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_security_group" "k8s-worker" {
  name = "k8s-worker"
  description = "k8s worker nodes security group"
  vpc_id = aws_vpc.vpc-k8s.id

  ingress = [ {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  }, {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  }, {
    description = "Allow HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  }, {
    description = "Allow VPC"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "172.16.0.0/16" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  } ]

  egress = [ {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
    description = null
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  } ]

  tags = {
    "Name" = "k8s-worker"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}
