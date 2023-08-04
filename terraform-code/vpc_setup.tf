provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.nano"
    key_name = "venkat-pem"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.public-subnet-01.id 

	for_each = toset(["jenkins-master", "build-slave", "ansible"])
   tags = {
     Name = "${each.key}"
     Env="Dev"
   }
}
	 

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.workshop-vpc.id 

  
  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

resource "aws_vpc" "workshop-vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "workshop-vpc"
  }
  
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id = aws_vpc.workshop-vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-subnet-01"
  }
}


resource "aws_subnet" "public-subnet-02" {
  vpc_id = aws_vpc.workshop-vpc.id
  cidr_block = "10.10.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-subent-02"
  }
}

resource "aws_internet_gateway" "workshop-igw" {
  vpc_id = aws_vpc.workshop-vpc.id 
  tags = {
    Name = "workshop-igw"
  } 
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.workshop-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.workshop-igw.id 
  }
}

resource "aws_route_table_association" "route-table-ass-public-subnet-01" {
  subnet_id = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public-route-table.id   
}

resource "aws_route_table_association" "route-table-ass-public-subnet-02" {
  subnet_id = aws_subnet.public-subnet-02.id 
  route_table_id = aws_route_table.public-route-table.id   
}
