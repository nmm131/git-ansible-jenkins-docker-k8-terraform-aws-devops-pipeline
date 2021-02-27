provider "aws" {
  profile = var.profile 
  region = var.aws_region
  shared_credentials_file = var.shared_credentials_file
}
resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type 
  key_name = var.key_name
  security_groups = var.aws_security_groups
  tags = {
    Name = "Jenkins"
  }
}
