# Technology Stack

This list reflects the implementation in this repository rather than optional
production technologies from the original draft.

| Technology | Use in this project |
|---|---|
| Terraform 1.17.2 | Defines, formats, validates, plans, and manages the infrastructure. |
| HashiCorp AWS provider 6.x | Terraform resources for AWS. The selected provider version is recorded in `.terraform.lock.hcl`. |
| AWS | Hosts the network, web tier, database, and monitoring. |
| AWS CLI v2 | SSO login, identity verification, and AWS command-line inspection. |
| IAM Identity Center | Human authentication using the `dev` AWS CLI profile; no long-lived credentials are placed in Terraform. |
| Amazon VPC | Network boundary with public, application-private, and database-private subnets across two AZs. |
| Internet Gateway and NAT Gateway | Internet traffic to the public ALB and outbound package/API access from private EC2 instances. A single NAT is used to contain cost, at the expense of AZ-level resilience. |
| Application Load Balancer | Exposes the static web demo over HTTP; optionally HTTPS when an existing Route 53 zone and domain are supplied. |
| EC2 and Auto Scaling Group | Runs Amazon Linux 2023 with Nginx; CPU target tracking scales between configured minimum and maximum. |
| IAM role and instance profile | Gives EC2 the AWS permissions needed for Systems Manager and CloudWatch Agent; no access keys on instances. |
| Amazon RDS for MySQL | Private, encrypted, single-AZ relational database. RDS manages the master password in Secrets Manager. The sample static site does not use this database. |
| Amazon CloudWatch | Stores configured EC2/Nginx logs and evaluates CPU and load-balancer health alarms. |
| Amazon S3 and DynamoDB | Optional, separate Terraform remote-state and locking resources in the backend bootstrap project. |
| Amazon Route 53 and ACM | Optional DNS and DNS-validated HTTPS for an already-owned domain and public hosted zone. |
| HTML, CSS, Nginx | Minimal static sample application, served from the EC2 instances. |
| Visual Studio Code and PowerShell | Editing and local command execution on Windows. |
| Git | Source versioning; no CI/CD pipeline is required for the baseline implementation. |

## Deliberately excluded

The implementation does not add Kubernetes, containers, a separate app
framework, CI/CD, multi-region failover, RDS Proxy, or a production database
application. These are not required to demonstrate the abstract's core
infrastructure workflow by the deadline.

## Cost and security notes

Terraform configuration is not free to run in AWS. A NAT Gateway and ALB have
ongoing charges; EC2, RDS, public IPv4 addresses, CloudWatch logs/alarms, and
the managed database secret may also incur charges. Current costs and free-tier
eligibility depend on account and regional terms. The single NAT Gateway,
single-AZ RDS, and one-instance default are demonstration settings, not
production high availability.

RDS is not public; its security group permits MySQL only from the application
security group. Application instances do not have public IPs, require IMDSv2,
and accept HTTP only from the ALB. The ALB accepts public HTTP. HTTPS is
disabled until a real domain and hosted zone are provided.
