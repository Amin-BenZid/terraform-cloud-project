module "network" {
  source = "../../modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  single_nat_gateway = var.single_nat_gateway
}

module "storage" {
  source = "../../modules/storage"

  project_name = var.project_name
  environment  = var.environment
}

module "security" {
  source = "../../modules/security"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  storage_bucket_arn    = module.storage.bucket_arn
  use_existing_lab_role = var.use_existing_lab_role
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
}

module "compute" {
  source = "../../modules/compute"

  project_name              = var.project_name
  environment               = var.environment
  instance_type             = var.instance_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  private_app_subnet_ids    = module.network.private_app_subnet_ids
  app_security_group_id     = module.security.app_security_group_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  target_group_arn          = module.load_balancer.target_group_arn
}

module "database" {
  source = "../../modules/database"

  project_name            = var.project_name
  environment             = var.environment
  private_db_subnet_ids   = module.network.private_db_subnet_ids
  db_security_group_id    = module.security.db_security_group_id
  db_instance_class       = var.db_instance_class
  db_password             = var.db_password
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
}