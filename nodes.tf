locals {
  type             = "node"
  ami              = "ami-0d497a49e7d359666"
  master_node_type = "t2.medium"
  worker_node_type = "t2.medium"
  sg_ids = [aws_security_group.kube-control-plane.id]
  key_paths = [
    "${path.module}/resources/master.pub",
    "${path.module}/resources/worker.pub"
  ]
}

module "master-1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "master-${local.type}"

  ami                    = local.ami
  #ami                    = "ami-0499632f10efc5a62"
  instance_type          = local.master_node_type
  key_name               = aws_key_pair.kube-keys[0].key_name
  monitoring             = true
  vpc_security_group_ids = local.sg_ids
  subnet_id              = module.vpc.public_subnets[0]
  ebs_block_device = [
    {
      device_name = "/dev/sda1"
      volume_size = 30
      volume_type = "gp2"
      encrypted   = false
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Type = "Master"
  }
}

module "node-1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "worker-${local.type}-1"

  ami                    = local.ami
  instance_type          = local.worker_node_type
  key_name               = aws_key_pair.kube-keys[1].key_name
  monitoring             = true
  vpc_security_group_ids = local.sg_ids
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    type = "Worker"
  }

    ebs_block_device = [
    {
      device_name = "/dev/sda1"
      volume_size = 30
      volume_type = "gp2"
      encrypted   = false
    },
    # ... any additional block devices ...
  ]
}

module "node-2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "worker-${local.type}-2"

  ami                    = local.ami
  instance_type          = local.worker_node_type
  key_name               = aws_key_pair.kube-keys[1].key_name
  monitoring             = true
  vpc_security_group_ids = local.sg_ids
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    type = "Worker"
  }

    ebs_block_device = [
    {
      device_name = "/dev/sda1"
      volume_size = 30
      volume_type = "gp2"
      encrypted   = false
    },
  ]
}

resource "aws_key_pair" "kube-keys" {
  for_each = { for id, path in local.key_paths : id => path }
  public_key = file(each.value)
}

resource "aws_eip_association" "eip_assoc-master" {
  instance_id   = module.master-1.id
  allocation_id = data.aws_eip.master1.id
}

resource "aws_eip_association" "eip_assoc-node-1" {
  instance_id   = module.node-1.id
  allocation_id = data.aws_eip.node1.id
}

resource "aws_eip_association" "eip_assoc-node-3" {
  instance_id   = module.node-2.id
  allocation_id = data.aws_eip.node2.id
}

data "aws_eip" "master1" {
  tags = {
    Name = "Master-1"
  }
}

data "aws_eip" "node1" {
  tags = {
    Name = "Node-1"
  }
}

data "aws_eip" "node2" {
  tags = {
    Name = "Node-2"
  }
}

