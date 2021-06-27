data "aws_ami" "ubuntu18" {
  most_recent = true

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ "099720109477" ]
}

resource "aws_network_interface" "k8s-master-01" {
  subnet_id = aws_subnet.sn-k8s-1.id
  security_groups = [ aws_security_group.k8s-master.id ]
  description = "Primary network interface"

  depends_on = [ aws_security_group.k8s-master, aws_subnet.sn-k8s-1 ]
}

resource "aws_network_interface" "k8s-worker-01" {
  subnet_id = aws_subnet.sn-k8s-2.id
  security_groups = [ aws_security_group.k8s-worker.id ]
  description = "Primary network interface"

  depends_on = [ aws_security_group.k8s-worker, aws_subnet.sn-k8s-2 ]
}

resource "aws_network_interface" "k8s-worker-02" {
  subnet_id = aws_subnet.sn-k8s-3.id
  security_groups = [ aws_security_group.k8s-worker.id ]
  description = "Primary network interface"

  depends_on = [ aws_security_group.k8s-worker, aws_subnet.sn-k8s-3 ]
}

resource "aws_eip" "k8s-master-01" {
  network_interface = aws_network_interface.k8s-master-01.id
  vpc = true

  tags = {
    "Name" = "k8s-master-01"
  }

  depends_on = [ aws_network_interface.k8s-master-01 ]
}

resource "aws_eip" "k8s-worker-01" {
  network_interface = aws_network_interface.k8s-worker-01.id
  vpc = true

  tags = {
    "Name" = "k8s-worker-01"
  }

  depends_on = [ aws_network_interface.k8s-worker-01 ]
}

resource "aws_eip" "k8s-worker-02" {
  network_interface = aws_network_interface.k8s-worker-02.id
  vpc = true

  tags = {
    "Name" = "k8s-worker-02"
  }

  depends_on = [ aws_network_interface.k8s-worker-02 ]
}

resource "aws_instance" "k8s-master-01" {
  ami = data.aws_ami.ubuntu18.id
  instance_type = "t3.medium"
  key_name = "aws-k8s"
  
  network_interface {
    network_interface_id = aws_network_interface.k8s-master-01.id
    device_index = 0
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    "Name" = "AWS-KM-01"
  }

  depends_on = [ aws_network_interface.k8s-master-01 ]
}

resource "aws_instance" "k8s-worker-01" {
  ami = data.aws_ami.ubuntu18.id
  instance_type = "t3.large"
  key_name = "aws-k8s"
  
  network_interface {
    network_interface_id = aws_network_interface.k8s-worker-01.id
    device_index = 0
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    "Name" = "AWS-KW-01"
  }

  depends_on = [ aws_network_interface.k8s-worker-01 ]
}

resource "aws_instance" "k8s-worker-02" {
  ami = data.aws_ami.ubuntu18.id
  instance_type = "t3.large"
  key_name = "aws-k8s"
  
  network_interface {
    network_interface_id = aws_network_interface.k8s-worker-02.id
    device_index = 0
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    "Name" = "AWS-KW-02"
  }

  depends_on = [ aws_network_interface.k8s-worker-02 ]
}
