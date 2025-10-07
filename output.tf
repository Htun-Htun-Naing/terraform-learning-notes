output "KKE_vpc_name" {
  value = aws_vpc.datacenter-priv-vpc.tags.Name
}

output "KKE_subnet_name" {
  value = aws_subnet.datacenter-priv-subnet.tags.Name
}

output "KKE_ec2_private" {
  value = aws_instance.datacenter-priv-ec2.tags.Name
}
