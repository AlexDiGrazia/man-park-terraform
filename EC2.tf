resource "aws_instance" "private_ec2" {
  count                       = 2
  ami                         = "ami-0a9271c49701613c1"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.private_ec2_SG.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false
  # subnet_id                   = module.vpc.private_subnet_ids[count.index]
  subnet_id                   = aws_subnet.private_subnet[count.index].id
 
  # user_data = file("./docker-script.sh")

  tags = {
    Name = "${var.app_name} Private EC2 instance ${count.index + 1}"
  }
}


output "private_ec2s" {
  value = aws_instance.private_ec2[*].id
}

resource "aws_instance" "bastion_host" {
  ami                         = "ami-0a9271c49701613c1"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.bastion_host_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private_subnet[0].id

  tags = {
    Name = "${var.app_name} Bastion Host"
  }
}