module "vpc" {
  source = "./modules/vpc/"
#   intra_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
}

module "ecs" {
  source = "./modules/ecs/"

  prefix                = var.prefix
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  public_subnets    = module.vpc.public_subnets
  db_address            = aws_db_instance.database.address
  db_name               = "jijun"
  db_username           =  "jijun"
  db_password_arn         = data.aws_secretsmanager_secret.db.arn
  db_secret_key_id      =  data.aws_secretsmanager_secret.db.id
  alb_target_group_arn  = module.vpc.aws_lb_target_group_arn
  alb_security_group_id = module.vpc.aws_security_group_id
}