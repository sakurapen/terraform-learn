resource "aws_vpc" "vpc-k8s" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "k8s"
  }
}

resource "aws_subnet" "sn-k8s-1" {
  vpc_id = aws_vpc.vpc-k8s.id
  cidr_block = "172.16.0.0/18"
  map_public_ip_on_launch = true
  availability_zone = "ap-east-1a"

  tags = {
    "Name" = "k8s-1"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_subnet" "sn-k8s-2" {
  vpc_id = aws_vpc.vpc-k8s.id
  cidr_block = "172.16.64.0/18"
  map_public_ip_on_launch = true
  availability_zone = "ap-east-1b"

  tags = {
    "Name" = "k8s-2"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_subnet" "sn-k8s-3" {
  vpc_id = aws_vpc.vpc-k8s.id
  cidr_block = "172.16.128.0/18"
  map_public_ip_on_launch = true
  availability_zone = "ap-east-1c"

  tags = {
    "Name" = "k8s-3"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_default_security_group" "sg-vpc-k8s" {
  vpc_id = aws_vpc.vpc-k8s.id

  ingress = [ {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  },{
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = false
  },{
    description = "defalut"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = null
    ipv6_cidr_blocks = null
    prefix_list_ids = null
    security_groups = null
    self = true
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

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "vpc-k8s"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_default_network_acl" "acl-vpc-k8s" {
  default_network_acl_id = aws_vpc.vpc-k8s.default_network_acl_id
  subnet_ids = [ aws_subnet.sn-k8s-1.id, aws_subnet.sn-k8s-2.id, aws_subnet.sn-k8s-3.id ]

  ingress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  egress {
    protocol = -1
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  tags = {
    "Name" = "k8s"
  }

  depends_on = [ aws_subnet.sn-k8s-1, aws_subnet.sn-k8s-2, aws_subnet.sn-k8s-3 ]
}

resource "aws_internet_gateway" "igw-k8s" {
  vpc_id = aws_vpc.vpc-k8s.id
  tags = {
    "Name" = "k8s"
  }

  depends_on = [ aws_vpc.vpc-k8s ]
}

resource "aws_default_route_table" "rtb-k8s" {
  default_route_table_id = aws_vpc.vpc-k8s.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-k8s.id
  }

  tags = {
    "Name" = "k8s"
  }

  depends_on = [ aws_internet_gateway.igw-k8s ]
}
