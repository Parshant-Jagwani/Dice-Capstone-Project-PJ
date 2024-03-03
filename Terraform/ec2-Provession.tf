provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "Main-VPC"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "172.31.1.0/24"

  tags = {
    Name = "main-subnet"
  }
}

# Create Internet-Gateway
resource "aws_internet_gateway"  "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Main-IGW"
  }
}

# Route table 
resource "aws_route_table" "main-route" {
  vpc_id = aws_vpc.main-vpc.id
  route {
      # Set the default route to go through the internet gateway
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id 
  }
  tags = {
    Name = "Main-RTB"
  }
}

#subnet_Accociation 
resource "aws_route_table_association" "main-rta" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main-route.id

}

# Aws_Security_Group 
resource "aws_security_group" "main-sg" { 
  name        = "Devops-Stack-Sg"
  description = "Devops-Stack-Sg"
  vpc_id      = aws_vpc.main-vpc.id

  ingress  {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    description = "Client container port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    description = "Server container port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Prometheus UI"
    from_port = 9000
    to_port = "9100"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "for Grafana UI"
    from_port = 3020
    to_port = 3120
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]

  }

  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
    Name = "Devops-Stack--Sg"
  }
}

# EC2 resources for Server
resource "aws_instance" "Server" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "devops-stack-kp"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Server"
  }
}

# EC2 resources for Client
resource "aws_instance" "Client" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "devops-stack-kp"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Client"
  }
}