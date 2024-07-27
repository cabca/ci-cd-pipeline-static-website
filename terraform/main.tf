provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0427090fd1714168b" # Amazon Linux 2 AMI (Change as per your region)
  instance_type = "t2.micro"

  tags = {
    Name = "StaticWebsiteServer"
  }
}