# Setup and Deployment Guide

This guide is for the internship demo in `ap-south-1`. It does not claim that
the infrastructure has been deployed.

## 1. Verify tools and SSO

Open a PowerShell terminal in VS Code. If necessary, expose the installed AWS
CLI in this terminal session:

```powershell
$env:Path += ";C:\Users\rahul\AppData\Local\Programs\Amazon\AWSCLIV2"
aws --version
```

Expected: an `aws-cli/2.x` version line.

Log in with the existing SSO profile and verify the identity:

```powershell
aws sso login --profile dev
aws sts get-caller-identity --profile dev
```

Expected: the caller-identity command returns an ARN. Never paste passwords,
access keys, secret keys, or session tokens into this repository.

## 2. Initialize and validate the application infrastructure

From `E:\AWSINTERN`:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe fmt -check -recursive
.\terraform_1.17.2_windows_amd64\terraform.exe init -input=false
.\terraform_1.17.2_windows_amd64\terraform.exe validate
```

Expected: formatting reports no changes, initialization completes, and
validation reports that the configuration is valid.

## 3. Generate and review a plan

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe plan -input=false -var-file="terraform.tfvars"
```

This reads AWS metadata to resolve AZs and an Amazon Linux AMI. It does not
create the resources. Carefully review the plan, especially resource
replacement/deletion actions and resources with hourly or storage charges.

## 4. Optional remote state bootstrap

The bootstrap project creates an S3 bucket and DynamoDB table. They are
separate AWS resources and may incur storage/request charges. The bucket name
includes the AWS account ID to reduce global naming collisions.

First initialize, validate, and plan the bootstrap from the `backend` folder:

```powershell
Set-Location E:\AWSINTERN\backend
..\terraform_1.17.2_windows_amd64\terraform.exe init -input=false
..\terraform_1.17.2_windows_amd64\terraform.exe fmt -check -recursive
..\terraform_1.17.2_windows_amd64\terraform.exe validate
..\terraform_1.17.2_windows_amd64\terraform.exe plan -input=false
```

**Stop here until you have reviewed the bootstrap plan and explicitly decided
to create the bucket and lock table.** No bootstrap apply was run by this
project work. If you choose to deploy the bootstrap yourself, the command is:

```powershell
..\terraform_1.17.2_windows_amd64\terraform.exe apply
```

Terraform will show a plan and ask for confirmation. Do not use
`-auto-approve`. After a successful bootstrap apply, record its outputs:

```powershell
..\terraform_1.17.2_windows_amd64\terraform.exe output
```

## 5. Optional migration to the S3 backend

Only after the backend bucket and table exist, go back to `E:\AWSINTERN`,
copy the example backend declaration, and initialize with the actual resource
names from the bootstrap outputs:

```powershell
Set-Location E:\AWSINTERN
Copy-Item .\backend.tf.example .\backend.tf
.\terraform_1.17.2_windows_amd64\terraform.exe init -migrate-state `
  -backend-config="bucket=<state-bucket-output>" `
  -backend-config="key=dev/terraform.tfstate" `
  -backend-config="region=ap-south-1" `
  -backend-config="profile=dev" `
  -backend-config="dynamodb_table=<lock-table-output>" `
  -backend-config="encrypt=true"
```

Replace the angle-bracketed values with the outputs from the bootstrap. Keep
the real bucket/table names private if required by your organization. Do not
commit local state files; `.gitignore` excludes them.

For staging and production, use a distinct state key (for example
`staging/terraform.tfstate` or `prod/terraform.tfstate`) and the matching
`-var-file`. Never point separate environments at the same state key.

## 6. Deploy only after explicit cost review and approval

The application plan can create a NAT Gateway, ALB, EC2 instances, RDS,
CloudWatch resources, IAM resources, and an RDS-managed secret. Charges can
continue while these are running. Review AWS pricing and the final plan first.
No deployment command is run automatically by these instructions.

If you explicitly choose to deploy after reviewing the plan:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe apply -var-file="terraform.tfvars"
```

Terraform displays the planned actions and requires confirmation. Do not add
`-auto-approve`.

After an approved apply, verify outputs and the application:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe output
Invoke-WebRequest -Uri (.\terraform_1.17.2_windows_amd64\terraform.exe output -raw application_url)
```

Expected: a successful HTTP response and the demo page. This is only an
expected result; it has not been observed until a deployment is performed.

## 7. Cleanup

Destroying resources can permanently delete the demo database; this
configuration skips the final RDS snapshot. Review a destroy plan and back up
any data before cleanup. Do not run destroy without explicit approval.
