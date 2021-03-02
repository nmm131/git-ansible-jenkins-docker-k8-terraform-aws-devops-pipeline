terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.30.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
}
provider "aws" {
  profile                 = var.profile
  region                  = var.aws_region
  shared_credentials_file = var.shared_credentials_file
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_availability_zones" "available" {
}

locals {
  cluster_name = "my-cluster"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "k8s-vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "12.2.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = var.eks_instance_type
    }
  }

  write_kubeconfig   = true
  config_output_path = "./"
}
resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = var.aws_security_groups
  tags = {
    Name = "Jenkins"
  }
  connection {
    type        = var.connection_type
    host        = aws_instance.web.public_ip
    user        = var.connection_user
    port        = var.connection_port
    private_key = file(var.connection_private_key)
    agent       = var.connection_agent
  }
  # Replace curl with ip of ec2-cluster
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo sh -c 'echo [ec2-cluster] >> /etc/ansible/hosts'",
      "sudo sh -c 'echo `curl http://checkip.amazonaws.com` >> /etc/ansible/hosts'",
      "sudo yum install git -y",
      "git clone https://github.com/nmm131/terraform-aws-ansible-jenkins-k8-elastic-devops-pipeline.git /tmp/ansible-aws",
      "ansible-playbook /tmp/ansible-aws/ansible/playbook-install-jenkins-kubernetes.yaml",
      "sudo mkdir /home/ec2-user/.kube"
    ]
  }
  provisioner "file" {
    source      = "/home/master/terraform-aws-ansible-jenkins-k8-elastic-devops-pipeline/terraform/kubeconfig_my-cluster"
    destination = "/home/ec2-user/.kube/config"
  }
}
