# Troubleshooting

## `aws` is not recognized in PowerShell

The AWS CLI is installed at
`C:\Users\rahul\AppData\Local\Programs\Amazon\AWSCLIV2\aws.exe`. In a VS Code
PowerShell terminal, add its folder to the current session's PATH:

```powershell
$env:Path += ";C:\Users\rahul\AppData\Local\Programs\Amazon\AWSCLIV2"
aws --version
```

This is temporary and does not reinstall the CLI. If the executable is not at
that location on your computer, use `Get-Command aws -All` and check the
installed AWS CLI location.

## SSO or expired-token errors

Authenticate with the profile:

```powershell
aws sso login --profile dev
aws sts get-caller-identity --profile dev
```

Confirm that the profile name in `terraform.tfvars` is `dev`. Do not replace
SSO with long-lived credentials in source files.

## Terraform says a variable is undeclared or duplicated

The root variables are in `variables.tf`. Module inputs are declared within
each corresponding module. Do not define the same root variable in
`provider.tf`; provider configuration should only reference variables.

## Terraform initialization fails

From the folder containing the root `main.tf`, run:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe init -input=false
```

If the backend configuration was just changed, review the backend migration
instructions in `DEPLOYMENT.md`. Do not delete `.terraform` or state files as
a first troubleshooting step.

## `terraform validate` reports formatting or HCL errors

Format the configuration and run validation again:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe fmt -recursive
.\terraform_1.17.2_windows_amd64\terraform.exe validate
```

Read the exact filename and line number in the diagnostic before editing.

## No available Availability Zones

The VPC module asks AWS for available AZs and uses the first two. Verify
`aws_region` is set to `ap-south-1` and that the AWS profile has permission to
describe AZs. Check whether the account has AZ restrictions.

## The EC2 target is unhealthy

The instance is private and depends on the NAT Gateway to install Nginx and
the CloudWatch agent during bootstrap. Check the Auto Scaling instance status,
target-group health reason, EC2 system log/user data, and the NAT route.
Cloud-init output is configured to be sent to the project CloudWatch log
group, if the instance has completed bootstrap and can reach AWS APIs.

## RDS creation or connectivity errors

RDS is intentionally private. Its security group accepts MySQL only from the
application security group, not from a developer laptop or the public
internet. Check the subnet group, AZ selection, security-group references,
and regional instance-class availability. Credentials are managed by RDS
through Secrets Manager and are not stored in `terraform.tfvars`.

## Bucket name already exists

S3 bucket names are globally unique. The bootstrap includes the AWS account
ID and region to reduce collisions. If creation still reports a conflict,
change the project identifier in the bootstrap variables and plan again.
