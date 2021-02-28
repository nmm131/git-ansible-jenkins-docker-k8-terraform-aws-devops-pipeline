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
  connection {
    type = var.connection_type
    host = aws_instance.web.public_ip
    user = var.connection_user
    port = var.connection_port
    private_key = file(var.connection_private_key)
    agent = var.connection_agent
  }
  # Replace curl with ip of ec2-cluster
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo sh -c 'echo [ec2-cluster] >> /etc/ansible/hosts'",
      "sudo sh -c 'echo `curl http://checkip.amazonaws.com` >> /etc/ansible/hosts'",
      "sudo yum install git -y",
      "git clone https://github.com/nmm131/terraform-aws-ansible-jenkins-k8-elastic-devops-pipeline.git /tmp/ansible-aws",
      "ansible-playbook /tmp/ansible-aws/ansible/playbook-install-jenkins-kubernetes.yaml"
    ]
  }
}
