
# Part 2: Creating VMs, Infra as a Code (IaC)

### ***1.*** Prerequisites for run Infra as a Code (IaC)
---

   ***a.***  [AWSCLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)  installed and configured with your AWS account. 
   
   ***b.*** Make an Session with your Local Machine by: `AWS_ACCESS_KEY_ID`and `AWS_SECRET_ACCESS_KEY`to [acheive this by Create your SECRET_KEY from AWS ROUTE USER `IAM`](https://www.wpdownloadmanager.com/how-to-generate-amazon-iam-access-key-and-secret-key/)
   
   ***c.*** Go to *Command-Line* write ```aws configure ```  and follow the instructions.
   Instructions will be look like this 
 
   ```
   /Users ~ > aws configure
   AWS Access Key ID  
   AWS Secret Access Key 
   Default region name  # Select your appropreate Region here such as 'us-east-1' or etc
   Default output format 'json'
   ```
   
   ***d.*** Install Terraform by following the instructions on this page [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

---   
### 2. Use Terraform for infrastructure automation. Place your Terraform scripts 
---
#### Configure the VPC and subnets appropriately to allow communication between the two EC2 instances. Use the t2.micro instance type, which is covered in the AWS free tier.

#### *To use this Terraform code [main.tf](main.tf), follow these steps:*

 **Step 1:** `terraform init`

 **Step 2:** `terraform Validate` 

 **Step 3:** `terraform plan` 

 **Step 4:** `terraform apply`