resource "aws_security_group" "kube-control-plane" {
  name        = "master-node-sg"
  description = "Necessary ports for kubernetes control-plane"
  vpc_id      = module.vpc.vpc_id

#  dynamic "ingress" {
#    for_each = [22, 443, 80, 6443]
#    content {
#      description      = "TLS from VPC"
#      from_port        = ingress.value
#      to_port          = ingress.value
#      protocol         = "tcp"
#      cidr_blocks      = ["0.0.0.0/0"]
#    }
#  }

#  ingress {
#    description      = "TLS from VPC"
#    from_port        = 443
#    to_port          = 443
#    protocol         = "tcp"
#    cidr_blocks      = [aws_vpc.main.cidr_block]
#    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
#  }

    ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Kube-Master"
  }
}