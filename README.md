# exosite-terraform-project
### Prerequisites

1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. AWS CLI set up and authenticated.
3. Ensure your AWS user has necessary permissions for EC2, Load Balancer, ACM, and other utilized services.
4. An existing key pair in AWS for SSH access to EC2.

### Deployment Steps:

1. **Initialization**:

   Navigate to the root of the project and run:
   
   terraform init

3. **Planning Phase**:

   This step generates an execution plan and ensures the resources will be created in the expected order.

   terraform plan

4. **Apply Changes**:

   This will provision the AWS resources as per the Terraform configurations.

   terraform apply

   Confirm with `yes` when prompted.

5. **Accessing the Webpage**:

   After successfully applying, you can access the Nginx webpage using the load balancer's public DNS, which will be shown as an output.

6. **Cleanup**:

   To delete all resources provisioned by Terraform:

   terraform destroy

   Confirm with `yes` when prompted.
