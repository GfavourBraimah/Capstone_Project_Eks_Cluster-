data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




resource "aws_key_pair" "ssh-key" {
  public_key = file(var.public_key_location)
}


resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.dev-subnet-1.id 
  vpc_security_group_ids = [ aws_default_security_group.default-sg.id ]
  availability_zone = var.avail_zone

  associate_public_ip_address = true 
  key_name = aws_key_pair.ssh-key.key_name
    
     user_data = file("install.sh")
     tags = {
    Name: "${var.env_prefix}-server"
  }

} 
