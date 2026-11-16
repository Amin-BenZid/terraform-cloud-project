# Module: compute

Creates an encrypted Launch Template running Amazon Linux 2023 with Nginx and an Auto Scaling Group across private application subnets with CPU target tracking.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `min_size` | Minimum ASG capacity | `number` | `2` | no |
| `max_size` | Maximum ASG capacity | `number` | `4` | no |
| `desired_capacity` | Desired ASG capacity | `number` | `2` | no |
| `private_app_subnet_ids` | Private application subnet IDs | `list(string)` | n/a | yes |
| `app_security_group_id` | Application Security Group ID | `string` | n/a | yes |
| `ec2_instance_profile_name` | IAM Instance Profile name | `string` | n/a | yes |
| `target_group_arn` | ALB Target Group ARN | `string` | n/a | yes |
| `cpu_target_value` | Target CPU % for scaling | `number` | `70` | no |

## Outputs

| Name | Description |
|------|-------------|
| `launch_template_id` | ID of the Launch Template |
| `autoscaling_group_name` | Name of the Auto Scaling Group |
| `autoscaling_group_arn` | ARN of the Auto Scaling Group |
| `ami_id` | Selected Amazon Linux 2023 AMI ID |

## Example

```hcl
module "compute" {
  source = "../../modules/compute"

  project_name              = "cloud5"
  environment               = "dev"
  private_app_subnet_ids    = module.network.private_app_subnet_ids
  app_security_group_id     = module.security.app_security_group_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  target_group_arn          = module.load_balancer.target_group_arn
}
```