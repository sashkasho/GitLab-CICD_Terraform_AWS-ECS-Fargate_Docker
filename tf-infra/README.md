# Terraform + AWS 
# EC2 + VPC + Remote Backend with AWS S3

## Description
Terraform Infrastructure for building EC2 with apache web server and Remote Backend (AWS S3). This infrastructure contains a module with network settings (VPC).

#### Requirements for manual deploy
There are packages below that should be installed on the (local) host where you'll be running deploy:
 * terraform >= 1.0.0
 * aws cli 
 
### Installation instructions to build the project by **manual**

*1. Get source code for install project:*  
```
git clone https://github.com/sashkasho/Terraform_EC2_VPC_Remote_Backend_Lecture5.git
```
*2. Go to the project folder*

*3. Add the keys from the IAM user with AdministratorAccess to the aws cli:*
```
aws configure
```

*4. Deploy the infrastructure. For all deploy by terraform.*
```
terraform init
terraform apply
```

### Installation instructions for creating a project in **Terraform Cloud**
*1. Get source code for install project:*  
```
git clone https://github.com/sashkasho/Terraform_EC2_VPC_Remote_Backend_Lecture5.git
```
*2. Go to your Terraform Cloud account and create a new Version Control Workspace*

*3. Add the keys from the IAM user with AdministratorAccess to the variables*
