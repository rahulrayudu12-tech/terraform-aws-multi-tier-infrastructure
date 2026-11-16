# Testing and Validation Record

## Local checks

| Check | Result | Notes |
|---|---|---|
| Terraform CLI version | Passed | Terraform v1.17.2, Windows AMD64. |
| AWS CLI version | Passed | AWS CLI v2.40.3 via installed executable path. |
| AWS SSO identity (`dev`) | Passed | `aws sts get-caller-identity --profile dev` succeeded; identity details are not repeated here. |
| Root `terraform fmt -check -recursive` | Passed | After modular implementation. |
| Root `terraform init -input=false` | Passed | Local modules initialized; AWS provider v6.73.0. |
| Root `terraform validate` | Passed | After fixing the CPU scaling policy's block placement. |
| Root `terraform plan -input=false -var-file="terraform.tfvars"` | Passed: 38 to add, 0 to change, 0 to destroy | Read-only plan against AWS; no resources created. |
| Backend `terraform fmt -check -recursive` | Passed | In `backend/`. |
| Backend `terraform init -input=false` | Passed | AWS provider v6.73.0 installed. |
| Backend `terraform validate` | Passed | In `backend/`. |
| Backend `terraform plan` | Passed: 5 to add, 0 to change, 0 to destroy | Read-only plan against AWS; no resources created. |
| Application HTTP check | Not run | No AWS deployment has been approved or performed. |

## Current progress and remaining evidence

The Terraform source and pre-deployment checks are complete (**80% overall
project progress**). The remaining work is a cost review and an explicitly
approved deployment, followed by HTTP, EC2, RDS, and CloudWatch verification
and genuine screenshots. No AWS resource creation or runtime success is
claimed.

See `PROJECT_STATUS.md` for the step-by-step work log, exact command outcomes,
cost caveats, and the next recommended action.

## Run the checks

From `E:\AWSINTERN` in PowerShell:

```powershell
.\terraform_1.17.2_windows_amd64\terraform.exe fmt -check -recursive
.\terraform_1.17.2_windows_amd64\terraform.exe init -input=false
.\terraform_1.17.2_windows_amd64\terraform.exe validate
.\terraform_1.17.2_windows_amd64\terraform.exe plan -input=false -var-file="terraform.tfvars"
```

The plan is read-only with respect to infrastructure creation, but uses AWS
API reads and can reveal the intended resource layout. Do not confuse a plan
with an apply or successful AWS deployment.

## Deployment evidence

No AWS resources, web endpoint, or CloudWatch behavior have been verified by
this implementation. Add genuine screenshots and results only after an
explicitly approved deployment and successful checks. Redact account IDs and
other identifying details before sharing screenshots.
