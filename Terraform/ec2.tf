provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "main-subnet"
  }
}

# Create Internet-Gateway
resource "aws_internet_gateway"  "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
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
    Name = "main-rtb"
  }
}

#subnet_Accociation 
resource "aws_route_table_association" "main-rta" {
  subnet_id = aws_subnet.main.id
  route_table_id = aws_route_table.main-route.id

}

# Aws_Security_Group 
resource "aws_security_group" "main-sg" { 
  name        = "allow_required_ports"
  description = "Allow required ports inbound traffic"
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

  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
    Name = "allow_required_ports"
  }
}

/* AMI lookup
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-LTS-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["363387917335"] # Canonical
}

*/

# EC2 resources for server
resource "aws_instance" "server" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "2-teir-app-kp"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "server"
  }
}

# EC2 resources for client
resource "aws_instance" "client" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "2-teir-app-kp"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "client"
  }
}