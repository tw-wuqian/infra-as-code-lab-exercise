resource "aws_ecs_task_definition" "this" {
  family                   = format("%s-ecs-task-definition", var.prefix)
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions = templatefile("./templates/container.json", {
    application      = "example_app"
    image_url        = aws_ecr_repository.api.repository_url
    cloudwatch_group = aws_cloudwatch_log_group.ecs.name
    region           = var.region
    db_address       = var.db_address
    db_name          = var.db_name
    db_username      = var.db_username
    db_password_arn  = var.db_secret_arn
  })

  runtime_platform {
    cpu_architecture = "ARM64" #or "X86_64" if not running on M1 chipset 
  }
}