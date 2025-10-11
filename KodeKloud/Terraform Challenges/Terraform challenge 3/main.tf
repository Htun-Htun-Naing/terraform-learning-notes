resource "aws_key_pair" "citadel-key" {
  key_name   = "citadel"
  public_key = file("/root/terraform-challenges/project-citadel/.ssh/ec2-connect-key.pub")
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "citadel"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "citadel"
  }
}

resource "aws_instance" "foo" {
  ami           = var.ami # us-west-2
  instance_type = var.instance_type
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.foo.id
  allocation_id = aws_eip.eip.id
}

resource "aws_eip" "eip" {
  vpc = true
  instance = aws_instance.foo.id
  
}