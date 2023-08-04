provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.nano"
    key_name = "venkat-pem"
	
	tags = {
	Name = "demo-1"
	env = "dev"
	}
	
}