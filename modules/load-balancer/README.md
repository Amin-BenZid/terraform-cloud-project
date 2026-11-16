# Module: load-balancer

Creates an internet-facing Application Load Balancer, HTTP listener, and Target Group with health checks.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `vpc_id` | VPC ID | `string` | n/a | yes |
| `public_subnet_ids` | Public subnet IDs (minimum 2) | `list(string)` | n/a | yes |
| `alb_security_group_id` | Security Group ID for ALB | `string` | n/a | yes |
| `app_port` | Target port on EC2 instances | `number` | `80` | no |
| `health_check_path` | Health check HTTP path | `string` | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `alb_arn` | ARN of the ALB |
| `alb_dns_name` | Public DNS name of the ALB |
| `target_group_arn` | ARN of the Target Group |

## Example

```hcl
module "load_balancer" {
  source = "../../modules/load-balancer"

  project_name          = "cloud5"
  environment           = "dev"
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}
```