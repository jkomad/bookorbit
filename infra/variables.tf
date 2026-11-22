variable "account_id" {
  description = "The IAM public access key"
}

variable "region" {
  description = "The AWS region things are created in"
}

variable "ec2_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role name"
  default     = "myEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}

variable "bookorbit_app_image" {
  description = "Bookorbit app Docker image to run in the ECS cluster"
  default     = "bookorbit-app:latest"
}

variable "bookorbit_db_image" {
  description = "Bookorbit DB Docker image to run in the ECS cluster"
  default     = "bookorbit-db:latest"
}

variable "bookorbit_app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3000"

}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "name" {
  description = "Environment-specific bookorbit stack name."
}

# container env vars 
variable "PUID" {
  description = "Postgres user"
  default     = "1000"
}

variable "PGID" {
  description = "Postgres group"
  default     = "1000"
}

variable "POSTGRES_HOST" {
  description = "Postgres host"
  default     = "bookorbit-db"
}

variable "POSTGRES_USER" {
  description = "Postgres user"
  default     = "bookorbit"
}

variable "POSTGRES_PASSWORD" {
  description = "Postgres password"
  sensitive   = true
}

variable "POSTGRES_DB" {
  description = "Postgres database name"
  default     = "bookorbit"
}

variable "JWT_SECRET" {
  description = "JWT secret for the bookorbit app"
  sensitive   = true
}

variable "SETUP_BOOTSTRAP_TOKEN" {
  description = "Bootstrap token"
  sensitive   = true
}


variable "NODE_MAX_OLD_SPACE_SIZE" {
  description = "Node.js max old space size in MB"
  default     = "2048"
}
