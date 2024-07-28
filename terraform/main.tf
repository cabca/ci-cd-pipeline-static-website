provider "aws" {
  region = "us-east-1"
}

data "aws_security_group" "existing_sg" {
  id = "sg-0329c9d10fea2a8ca"
}

resource "aws_instance" "web" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  key_name      = "GITHUB-ACTIONS-PIPELINE-KEY-PAIR"

  tags = {
    Name = "web"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}