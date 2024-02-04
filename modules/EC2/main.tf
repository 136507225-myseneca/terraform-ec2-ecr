


# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Create an EC2 instance in the public subnet
resource "aws_instance" "my_instance" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = var.aws_subnet_id
  security_groups             = var.security_groups
  associate_public_ip_address = true

  tags = {
    Name = "MyInstance"
  }
}
