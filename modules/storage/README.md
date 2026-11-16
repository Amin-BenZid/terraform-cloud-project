# Module: storage

Creates a private S3 bucket for logs, assets, and backups with versioning, AES256 encryption, public access blocking, and lifecycle rules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project prefix for naming | `string` | n/a | yes |
| `environment` | Target environment (`dev`, `test`, `prod`) | `string` | n/a | yes |
| `noncurrent_expiration_days` | Days before noncurrent versions expire | `number` | `30` | no |
| `transition_ia_days` | Days before transition to STANDARD_IA | `number` | `30` | no |
| `use_cli_bucket_creation` | Bypass Learner Lab SCP on ObjectLock | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |

## Example

```hcl
module "storage" {
  source = "../../modules/storage"

  project_name = "cloud5"
  environment  = "dev"
}
```