# bookorbit services in private subnets= app and db 
# =latest is the fallback tag 

locals {
  app_env = {
    NODE_ENV              = "production"
    PORT                  = var.bookorbit_app_port
    POSTGRES_HOST         = var.POSTGRES_HOST
    POSTGRES_PORT         = "5432"
    POSTGRES_USER         = var.POSTGRES_USER
    POSTGRES_PASSWORD     = var.POSTGRES_PASSWORD
    POSTGRES_DB           = var.POSTGRES_DB
    JWT_SECRET            = var.JWT_SECRET
    SETUP_BOOTSTRAP_TOKEN = var.SETUP_BOOTSTRAP_TOKEN
  }

  service_names = { app = "${var.name}-app" }

  services = {
    app = { name = "app", cpu = 256, memory = 512, port = 3000, env = local.app_env, secrets = [] }
  }
}

module "ecr" {
  source               = "./modules/ecr"
  for_each             = local.services
  repo_name            = "bookorbit-${local.services[each.key].name}"
  image_tag_mutability = "MUTABLE"
  keep_tagged          = 5
}

resource "aws_cloudwatch_log_group" "svc" {
  for_each          = local.services
  name              = "/ecs/${local.service_names[each.key]}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "svc" {
  for_each                 = local.services
  family                   = local.service_names[each.key]
  skip_destroy             = true # keep earlier revisions registered so a rollback can still start them
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  container_definitions = jsonencode([{
    name         = "bookorbit-${each.key}"
    image        = "${module.ecr[each.key].repo_url}:latest"
    essential    = true
    portMappings = [{ containerPort = each.value.port, protocol = "tcp" }]
    environment  = [for k, v in each.value.env : { name = k, value = v }]
    secrets      = each.value.secrets
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.svc[each.key].name
        awslogs-region        = var.region
        awslogs-stream-prefix = each.key
      }
    }
  }])
}
