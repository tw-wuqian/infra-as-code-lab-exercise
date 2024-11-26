output "vpc_id" {
  description = "The Elastic Container Registry (ECR) URL."
  value       = module.vpc.vpc_id
}

output "aws_lb_target_group_id" {
  description = "The Elastic Container Registry (ECR) URL."
  value       = aws_lb_target_group.tg.id
}

output "aws_security_group_id" {
  description = "The Elastic Container Registry (ECR) URL."
  value       = aws_security_group.lb_sg.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "intra_subnets" {
  value = aws_subnet.intra[*].id
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.tg.arn
}


