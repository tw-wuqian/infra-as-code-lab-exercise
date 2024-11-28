output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.vpc.intra_subnets
}

output "aws_lb_target_group_arn" {
  description = "List of IDs of intra subnets"
  value       = module.vpc.aws_lb_target_group_arn
}