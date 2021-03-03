# Terraform AWS Ansible Jenkins K8 Elastic Devops Pipeline
Prerequisites:

1. VM with Terraform and AWSCLI Installed.

## Jenkins Configuration as Code (JCASC) on AWS EC2 Instance
### Create a key pair
1. Sign in to the Open the [Amazon EC2 console](https://console.aws.amazon.com/ec2/ "Amazon EC2 console").
2. In the navigation pane, under NETWORK & SECURITY, choose Key Pairs.
3. Select Create key pair.
4. Use the following command to set the permissions of your private key file so that only you can read it.
```chmod 400 <key_pair_name>.pem```
NOTE: Use `scp` to copy it to your VM if you downloaded the .pem file from another machine:
```scp "<path_to_key>/Jenkins.pem" <user>@<host>:<path_to_key>/<key_pair_name>.pem```

### Create a security group
1. Sign in to the [AWS Management Console](https://console.aws.amazon.com/ec2/ "AWS Management Console").
2. Open the Amazon EC2 console by choosing EC2 under Compute.
3. Choose your VPC from the list, you can use the default VPC.
4. Find your IP address and . You may use the [checkip service](http://checkip.amazonaws.com/ "checkip service") from AWS3. Run this from your VM that has access to the `<key_pair_name>.pem` file.
5. On the Inbound tab, add the rules as follows:
	1. Click Add Rule, and then choose SSH from the Type list. Under Source, select Custom and in the text box enter <public IP address range that you decided on in step 1>/32 i.e 172.23.23.165/32.
	2. Click Add Rule, and then choose HTTP from the Type list. Enter 0.0.0.0/0
	3. Click Add Rule, and then choose Custom TCP Rule from the Type list. Under Port Range enter 8080. Enter 0.0.0.0/0
	4. Click Create.

### Launch an Amazon EC2 instance Installed with Jenkins Configuration as Code pre-loaded with a Jenkins Job
#### Connect to your Linux instance
1. Clone the project on your VM.
3. Create variables.tfvars
4. Run the command: ```aws configure```. This will create a `credentials` file, known as AWS Credentials, for you in `~/.aws` as well as a `config` file.
2. Run the command: ```terraform apply -auto-approve --var-file variables.tfvars```
3. Before you connect to your instance, get the public DNS name of the instance using the Amazon EC2 console. Select the instance and locate Public DNS.
2. Use the ssh command to connect to the instance. You will specify the private key (.pem) file and ec2-user@public_dns_name:
	3. ```ssh -i <path_to_key>/<key_pair_name>.pem ec2_user@<ec2_public_dns>``` NOTE: `ec2_user` is the default ec2 instance user. Replace it if you have setup another user.
3. Copy the Key and AWS Credentials files on your VM to the EC2 Instance.
3. SSH into your EC2 Jenkins Container: ```ssh -i <path_to_key>/<key_name>.pem ec2-user@<ec2_public_ip>``` then run the following commands:
	1. ```aws configure``` and input `AWS Access Key ID`, `AWS Secret Access Key`, `Default Region Name` and `Default Output Format`.
	2. ```aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw cluster_name)```
4. In Jenkins (access the dashboard from a URL), re-build the Jenkins job. Make sure the kube config file copied correctly if not then re-run terraform apply command then re-build the Jenkins job.
5. In EC2 Jenkins Container, run the command: ```kubectl port-forward <pod_name_example_wfjdz> 5000:5000```
6. Go to your EKS Cluster's `API server endpoint` appended with port 5000 in a browser.


## AWS Elasticsearch Service Monitoring with Metricbeat and Filebeat 

## Thoughts
1. JCASC Environment Variables poses a security risk
2. Mounting Docker .sock poses a security risk
3. Ended up installing Docker on jcasc container because trying to pass /usr/bin/causes docker to exit container after 1 second
4. Automate AWS Key and Security Group
5. Automate AWS Elasticsearch Domain
4. How to automate Ansible Credentials and ssh on two machines
5. How to wait for EKS before EC2 runs `ansible-playbook` command
5. ****** HOW TO CONFIGURE JENKINS CONTAINER WITH AWS CONFIGURE AND AWS EKS REGION AND KUBECONFIG ----> EASIEST WAY IS JCASC STARTS W/ JOB AND AWS CREDENTIALS VIA DASHBOARD******

### Help Manually Destroying AWS Cluster
1. Tearing down cluster manually use this command after: ```terraform state rm module.eks.kubernetes_config_map.aws_auth```