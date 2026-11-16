# Module: network

Creates the multi-AZ VPC architecture including public, private application, and isolated private database subnets, an Internet Gateway, NAT Gateway(s), and route tables.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `vpc_cidr` | `/16` IPv4 CIDR block for the VPC | `string` | `"10.20.0.0/16"` | no |
| `single_nat_gateway` | Use 1 NAT Gateway instead of 2 | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the VPC |
| `vpc_cidr` | CIDR block of the VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_app_subnet_ids` | List of private application subnet IDs |
| `private_db_subnet_ids` | List of private database subnet IDs |
| `nat_gateway_ids` | List of NAT Gateway IDs |

## Example

```hcl
module "network" {
  source = "../../modules/network"

  project_name       = "cloud5"
  environment        = "dev"
  vpc_cidr           = "10.20.0.0/16"
  single_nat_gateway = true
}
```