# Module: database

Provisions a private, encrypted Amazon RDS MySQL 8.4 instance inside dedicated private DB subnets with a custom parameter group.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `private_db_subnet_ids` | Private DB subnet IDs (minimum 2) | `list(string)` | n/a | yes |
| `db_security_group_id` | RDS Security Group ID | `string` | n/a | yes |
| `db_instance_class` | RDS instance class | `string` | `"db.t3.micro"` | no |
| `db_name` | Initial database name | `string` | `"appdb"` | no |
| `db_username` | Master username | `string` | `"adminuser"` | no |
| `db_password` | Master password (`sensitive`, pass via env/secret) | `string` | n/a | yes |
| `multi_az` | Enable Multi-AZ high availability | `bool` | `false` | no |
| `backup_retention_period` | Automated backup retention in days | `number` | `1` | no |
| `skip_final_snapshot` | Skip final snapshot on destroy | `bool` | `true` | no |
| `deletion_protection` | Enable deletion protection | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `db_instance_id` | RDS instance identifier |
| `db_instance_endpoint` | RDS `host:port` endpoint |
| `db_instance_address` | RDS private DNS hostname |
| `db_instance_port` | RDS port |
| `db_subnet_group_name` | DB Subnet Group name |

## Example

```hcl
module "database" {
  source = "../../modules/database"

  project_name          = "cloud5"
  environment           = "dev"
  private_db_subnet_ids = module.network.private_db_subnet_ids
  db_security_group_id  = module.security.db_security_group_id
  db_password           = var.db_password
}
```