variable "hosted_zone_id" {
  description = "Hosted zone ID from Route53 domain"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Name of project"
  type        = string
  default     = "demo"
}

variable "task" {
  description = "Task parameters"
  type = object({
    name           = string
    port           = number
    instance_count = number
    cpu            = number
    memory         = number
    healthcheck    = string
  })
  default = {
    name           = "application"
    port           = 8080
    instance_count = 1
    cpu            = 256
    memory         = 512
    healthcheck    = "/api/healthcheck"
  }
}

variable "domain" {
  description = "Full domain of app in hosted zone"
  type        = string
  default     = "www.foo.com"
}
