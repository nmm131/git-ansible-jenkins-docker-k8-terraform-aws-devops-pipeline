# Jenkins on Cloud
Follow the tutorial [here](https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/ "Install Jenkins on AWS").

## Create a key pair
1. Sign in to the Open the [Amazon EC2 console](https://console.aws.amazon.com/ec2/ "Amazon EC2 console").
2. In the navigation pane, under NETWORK & SECURITY, choose Key Pairs.
3. Select Create key pair.
4. Use the following command to set the permissions of your private key file so that only you can read it.
```chmod 400 <key_pair_name>.pem```
NOTE: Use `scp` to copy it to your machine if you downloaded the .pem file from another machine:
```scp "<path_to_key>/Jenkins.pem" <user>@<host>:/<path_to_key>/<key_pair_name>.pem```

## Create a security group
1. Sign in to the [AWS Management Console](https://console.aws.amazon.com/ec2/ "AWS Management Console").
2. Open the Amazon EC2 console by choosing EC2 under Compute.
3. Choose your VPC from the list, you can use the default VPC.
4. Find your IP address and . You may use the [checkip service](http://checkip.amazonaws.com/ "checkip service") from AWS3. Run this from your host machine that has access to the `<key_pair_name>.pem` file.
5. On the Inbound tab, add the rules as follows:
	1. Click Add Rule, and then choose SSH from the Type list. Under Source, select Custom and in the text box enter <public IP address range that you decided on in step 1>/32 i.e 172.23.23.165/32.
	2. Click Add Rule, and then choose HTTP from the Type list. Enter 0.0.0.0/0
	3. Click Add Rule, and then choose Custom TCP Rule from the Type list. Under Port Range enter 8080. Enter 0.0.0.0/0
	4. Click Create.

## Launch an Amazon EC2 instance
1. Sign in to the the [AWS Management Console](https://console.aws.amazon.com/ec2/ "AWS Management Console").
2. From the Amazon EC2 dashboard, choose Launch Instance.
3. Select the HVM edition of the Amazon Linux AMI. Notice that this configuration is marked Free tier eligible.
4. Choose an Instance Type page, the t2.micro instance is selected by default. Keep this instance type to stay within the free tier.
5. On the Review Instance Launch page, click Edit security groups.
6. On the Configure Security Group page:
	1. Select Select an existing security group.
	2. Select the WebServerSG security group that you created.
	3. Click Review and Launch.
7. On the Review Instance Launch page, click Launch.
8. In the Select an existing key pair or create a new key pair dialog box, select Choose an existing key pair, and then select the key pair you created in the `Create a key pair using Amazon EC2` section above
9. In the left-hand navigation bar, choose Instances to see the status of your instance. Initially, the status of your instance is pending. After the status changes to running, your instance is ready for use.

## Install and configure Jenkins
### Connect to your Linux instance
1. Before you connect to your instance, get the public DNS name of the instance using the Amazon EC2 console. Select the instance and locate Public DNS.
2. Use the ssh command to connect to the instance. You will specify the private key (.pem) file and ec2-user@public_dns_name:
3. ```ssh -i /<path_to_key>/<key_pair_name>.pem ec2_user@<ec2_public_dns>``` NOTE: `ec2_user` is the default ec2 instance user. Replace it if you have setup another user. 