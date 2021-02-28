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
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      "git clone https://github.com/nmm131/terraform-aws-ansible-jenkins-k8-elastic-devops-pipeline.git /tmp/ansible-aws",
      "ansible-playbook /tmp/ansible-aws/ansible/playbook-install-jenkins-kubernetes.yaml"
    ]
  }
}
