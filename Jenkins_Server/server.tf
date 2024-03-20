



resource "aws_instance" "myapp-server" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.dev-subnet-1.id 
  vpc_security_group_ids = [ aws_default_security_group.default-sg.id ]
  availability_zone = var.avail_zone
  associate_public_ip_address = true 
  key_name = var.key_name
    
     user_data = file("install.sh")
     tags = {
    Name: "${var.env_prefix}-server"
  }

} 
