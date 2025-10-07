resource "aws_vpc" "datacenter-priv-vpc" {
  cidr_block = var.KKE_VPC_CIDR
  tags = {
    Name = "datacenter-priv-vpc"
  }
}
resource "aws_subnet" "datacenter-priv-subnet" {
  vpc_id            = aws_vpc.datacenter-priv-vpc.id
  cidr_block        = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false
  tags = {
    Name = "datacenter-priv-subnet"
  }
}
resource "aws_instance" "datacenter-priv-ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID, replace with a valid one for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.datacenter-priv-subnet.id
  vpc_security_group_ids = [aws_security_group.xfusion_sg.id]
  tags = {
    Name = "datacenter-priv-ec2"
  }
}

resource "aws_security_group" "xfusion_sg" {
  name        = "xfusion-private-sg"
  description = "Allow traffic only from within the VPC"
  vpc_id      = aws_vpc.datacenter-priv-vpc.id
  
  # Ingress rule to allow all traffic from the VPC's CIDR block
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "xfusion-private-sg"
  }
}