# Module: security

Creates least-privilege Security Groups for the ALB, application instances, and RDS database, as well as the EC2 IAM Instance Profile.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `vpc_id` | VPC ID | `string` | n/a | yes |
| `app_port` | Application listening port | `number` | `80` | no |
| `db_port` | Database listening port | `number` | `3306` | no |
| `allowed_http_cidrs` | Allowed Internet CIDRs for ALB | `list(string)` | `["0.0.0.0/0"]` | no |
| `storage_bucket_arn` | S3 bucket ARN for least-privilege IAM | `string` | `""` | no |
| `use_existing_lab_role` | Use pre-existing `LabInstanceProfile` | `bool` | `true` | no |
| `existing_instance_profile_name` | Existing IAM instance profile name | `string` | `"LabInstanceProfile"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `alb_security_group_id` | ALB Security Group ID |
| `app_security_group_id` | Application Security Group ID |
| `db_security_group_id` | Database Security Group ID |
| `ec2_instance_profile_name` | EC2 IAM Instance Profile name |

## Example

```hcl
module "security" {
  source = "../../modules/security"

  project_name = "cloud5"
  environment  = "dev"
  vpc_id       = module.network.vpc_id
}
```