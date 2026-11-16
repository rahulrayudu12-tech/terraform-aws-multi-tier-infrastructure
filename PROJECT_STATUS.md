# Project Status

## Project

Terraform-Based Infrastructure Deployment on AWS

## Overall progress

**80% complete.** The requested project structure and core Terraform
implementation are present, documented, formatted, initialized, validated,
and planned against the configured AWS account. The remaining 20% is
deployment-dependent verification and evidence, plus an informed cost/approval
decision. No AWS resources have been created by this work.

| Requirement area | Status | Evidence / remaining work |
|---|---|---|
| Inspect abstract and audit existing workspace | Complete | `Terraform1.docx` read as the primary requirement source; initial workspace compared with its requirements. |
| Fix local Terraform and AWS CLI configuration issue | Complete | Duplicate region variable fixed; AWS CLI v2.40.3 and SSO `dev` identity verified. |
| Requested modular Terraform project layout | Complete | Root files, VPC/security/EC2/ALB/RDS/monitoring modules, app, backend bootstrap, and environment examples exist. |
| Multi-tier AWS network and security | Implemented and planned | Public, private application, and private database subnets; IGW, NAT, routes, and tier-restricted security groups. |
| Load-balanced web application and scaling | Implemented and planned | ALB, static Nginx page, EC2 Auto Scaling Group, CPU target tracking. |
| Managed database and monitoring | Implemented and planned | Private encrypted MySQL RDS, AWS-managed DB password, CloudWatch logs and alarms. The static demo does not connect to RDS. |
| State backend and environments | Implemented and separately planned | Optional S3/DynamoDB bootstrap; staging and prod tfvars examples. Backend is not applied. |
| Documentation and submission guidance | Complete | README, architecture/Mermaid, tech stack, deployment, testing, troubleshooting, and status files. |
| Terraform local checks and AWS plan | Passed | Root plan: 38 additions, 0 changes, 0 destroys. Separate backend plan: 5 additions, 0 changes, 0 destroys. |
| AWS deployment, runtime verification, screenshots | Not performed | Requires explicit deployment decision; deployed app/CloudWatch evidence is not available. |
| Current cost estimate | Pending | Must be researched for account, region, and run duration before any deployment decision. |

## Steps performed

1. Inventoried the workspace and read `Terraform1.docx`,
   `TECHSTACK.md`, `terraform_aws_architecture.md`, and the existing Terraform
   files.
2. Compared the existing one-resource VPC configuration with the abstract's
   required multi-tier AWS architecture.
3. Verified Terraform v1.17.2 and AWS CLI v2.40.3. Verified IAM Identity
   Center authentication using `aws sts get-caller-identity --profile dev`;
   no credentials or tokens were displayed.
4. Fixed the duplicate `aws_region` declaration in the original configuration.
   The following stray PowerShell PATH command found appended to the variable
   file was removed after the user approved the repair. Valid variables were
   retained in the requested `variables.tf`.
5. Implemented the root Terraform configuration and VPC, security, ALB, EC2,
   RDS, and monitoring modules, plus the static HTML demo, development
   variables, environment examples, and outputs.
6. Added a separate, optional backend bootstrap for the S3 state bucket and
   DynamoDB lock table, along with a root backend example and migration guide.
7. Rewrote the architecture and technology stack to match the code, and
   created README, deployment, testing, troubleshooting, and project-status
   documentation.
8. Formatted and initialized both Terraform roots, validated both roots, and
   ran non-deploying plans against AWS read APIs.
9. Fixed a misplaced Auto Scaling policy block found during validation and
   reran root initialization, validation, and plan successfully.

## Files created, modified, or removed

- Root: `.gitignore`, `.terraform.lock.hcl`, `main.tf`, `provider.tf`,
  `variables.tf`, `versions.tf`, `outputs.tf`, `terraform.tfvars`.
- Modules: `modules/vpc/`, `modules/security/`, `modules/ec2/`,
  `modules/alb/`, `modules/rds/`, `modules/monitoring/`.
- Demo app: `app/index.html`.
- Optional state backend: `backend/backend.tf`, `backend/variables.tf`,
  `backend/versions.tf`, `backend/outputs.tf`, `backend/.terraform.lock.hcl`,
  and root `backend.tf.example`.
- Environments: `environments/staging.tfvars`,
  `environments/prod.tfvars`.
- Documentation: `README.md`, `TECHSTACK.md`,
  `terraform_aws_architecture.md`, `DEPLOYMENT.md`, `TESTING.md`,
  `TROUBLESHOOTING.md`, `PROJECT_STATUS.md`.
- Removed the obsolete `variable.tf` after migrating its valid declarations to
  `variables.tf` and removing the stray shell command.

## Commands executed and actual results

| Command/check | Result |
|---|---|
| Terraform `version` | Passed: v1.17.2, Windows AMD64. |
| AWS CLI `--version` using installed executable path | Passed: AWS CLI v2.40.3. |
| `aws sts get-caller-identity --profile dev` | Passed; SSO identity was returned. |
| Root `terraform fmt -recursive` | Passed; formatted root and module files. |
| Root `terraform init -input=false` | Passed; modules initialized and AWS provider v6.73.0 reused. |
| Root `terraform validate` | Passed after correcting the Auto Scaling policy block. |
| Root `terraform plan -input=false -var-file="terraform.tfvars"` | Passed: 38 to add, 0 to change, 0 to destroy. Read-only plan; no AWS resources created. |
| Backend `terraform fmt -check -recursive` | Passed. |
| Backend `terraform init -input=false` | Passed; AWS provider v6.73.0 installed. |
| Backend `terraform validate` | Passed. |
| Backend `terraform plan` | Passed: 5 to add, 0 to change, 0 to destroy. Read-only plan; no AWS resources created. |
| ALB HTTP request, EC2 bootstrap, RDS status, or CloudWatch runtime check | Not run; requires deployed resources. |

## Errors and fixes

- The original root configuration could not initialize because
  `aws_region` was declared twice. Consolidated it into `variables.tf`.
- The prior shell PATH command was accidentally appended to the variable file.
  Removed that line after confirmation and preserved the HCL variables.
- The first modular validation found the CPU target-tracking policy nested
  inside the Auto Scaling Group resource. Moved it to a top-level resource;
  root validation and plan subsequently passed.
- An initial verification ran validate before Terraform had installed the new
  local modules and initialized the separate backend provider. Initialized
  each root and repeated validation successfully.

## Safety, cost, and limitations

- `terraform plan` is not deployment. No `terraform apply`, `terraform
  destroy`, or AWS resource creation was performed.
- The application plan proposes 38 additions; the separate state-backend plan
  proposes another 5. NAT Gateway, ALB, EC2, RDS, public IPv4 addresses,
  CloudWatch, and the managed DB secret can incur charges. Current regional
  pricing and account-specific free-tier eligibility have not been estimated.
- The demo uses one NAT Gateway, one desired EC2 instance (scalable up to
  two), single-AZ RDS, HTTP by default, and skips a final RDS snapshot on
  deletion. It is not production-ready or highly available across all
  failure modes.
- Route 53 and ACM are optional and require an existing domain and hosted
  zone. The static demo page does not consume RDS.
- The workspace Git root is `E:\`, which includes unrelated sibling content.
  No files in sibling projects were modified.

## Remaining work and next step

1. Estimate current AWS charges for the exact plans and intended deployment
   duration.
2. Review the cost and decide whether to explicitly authorize a deployment.
   No apply should run without that separate approval.
3. If approved and deployed, verify the ALB URL, target health, EC2 bootstrap,
   RDS status, and CloudWatch logs/alarms. Record only observed results in
   `TESTING.md` and capture genuine screenshots.
4. Decide separately whether to create the optional S3/DynamoDB backend.

### NEXT INSTRUCTION FOR THE USER

No terminal command is required yet. Review `PROJECT_STATUS.md` and
`DEPLOYMENT.md`. If you want deployment, ask for a current cost estimate first;
this is not authorization to apply. Do not run `terraform apply` or
`terraform destroy` yet.
