# Infra as Code - Lab Exercises

## Overview

This code repository accompanies the slides, videos and demo code for the Infra as Code course which has 6 sessions.  There is a folder for each session which contains the session's lab exercises.  As we work through the sessions we will make improvements to the code base which builds a working solution.  In each of the sessions we will follow the same authentication, deployment and destruction processes which can be found below.  The course trainer will share the solutions to the lab exercises after you have completed them.

## Sessions

- [Session_1_IaC_and_Terraform_Intro](./Session_1_IaC_and_Terraform_Intro/README.md)
- [Session_2_Terraform_Basics](./Session_2_Terraform_Basics/README.md)
- [Session_3_Terraform_State](./Session_3_Terraform_State/README.md)
- [Session_4_Terraform_Tips_n_Tricks](./Session_4_Terraform_Tips_n_Tricks/README.md)
- [Session_5_Terraform_Modules](./Session_5_Terraform_Modules/README.md)
- [Session_6_Terraform_Cloud_and_Pipelines](./Session_6_Terraform_Cloud_and_Pipelines/README.md)

### Pre-requisites

#### AWS Console Access

You need to have access to the TW_TDEV_INFRACA:CORTEAM:DEV AWS account (510769981514) and be able to log in to the console (UI) as well as authenticate using the AWS CLI (instructions below).

#### AWS CLI Installed and Configured

To run Terraform we need to authenticate and it's easiest to do that using the AWS CLI.  To install aws cli run the following if it's not already installed:

```
brew install awscli
```

Configure the AWS CLI to work through MFA using AWS STS to provide short lived access keys by adding this snippet of code into ~/.aws/config only if you don’t already have it configured (create the config file if it doesn't exist, also update the profile name, role name, region and output as you see fit):

```
[profile twinfra]
sso_start_url = https://thoughtworks-sso.awsapps.com/start
sso_region = eu-central-1
sso_account_id = 510769981514
sso_role_name = PowerPlusRole_InfraAcademy
region = ap-southeast-2
output = json
```

Now run the following command in your terminal.

```
aws sso login --profile twinfra
```

It should open a browser window and will prompt you to authorise the request.  Once authorised you should run the following to set your AWS profile in your terminal (update the profile name to the profile you are using):

```
export AWS_PROFILE=twinfra
```

Now if you run any AWS commands it will detect your already authenticated profile and should be able to interact with AWS, test it out by running  the following command:

```
aws ec2 describe-regions
```

#### Install Terraform

[Installation instructions](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


#### Update the Region (If Applicable)

In the region variable or in the *.tfvars file there is a value specified for the region, you should update the region to match your AWS profile region.


### Deploy Instructions:

Navigate to the root of the session folder and then run the following command to initialise the Terraform project, this will pull down the Terraform modules required by the code:

```
terraform init
```

Run the following command to see if the Terraform is valid and identify what resources it plans to create, update or destroy:

```
terraform plan
```

Run the following command to deploy the Terraform and create the resources.

```
terraform apply
```

Once the script has completed it should return the Terraform output data.  You should also log in to the AWS console and have a look at the resources that were created.

Run the following command to view the resources that Terraform created:

```
terraform state list
```

### Destroy Instructions:

Run the following command to destroy all the resources:

```
terraform destroy
```

Log in to the AWS console to verify all the resources have been terminated.
