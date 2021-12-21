variable "aws_region" {
  default     = "eu-west-1"
  description = "aws region"
}

variable "az_count" {
  default     = "2"
  description = "number of availability zones"
}

variable "ecs_task_execution_role" {
  default     = "demoEcsTaskExecutionRole"
  description = "name of ECS task execution role"
}

variable "app_image_blue" {
  default     = "demo-nginx:1.0"
  description = "docker image to run in this ECS cluster for blue environment"
}

variable "app_image_green" {
  default     = "demo-nginx:1.1"
  description = "docker image to run in this ECS cluster for green environment"
}

variable "app_port" {
  default     = "80"
  description = "port exposed on the docker image"
}

variable "app_count" {
  default     = "2"
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision in MiB"
}

# the following varilables are related to blue green deployments
variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = true
}

variable "green_instance_count" {
  description = "Number of instances in green environment"
  type        = number
  default     = 2
}

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}


