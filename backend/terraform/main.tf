

provider "aws" {
  region = var.region
}



data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}



locals {
  project = "devops-assignment"

  common_tags = {
    Project   = local.project
    ManagedBy = "Terraform"
  }
}



resource "aws_ecr_repository" "backend" {
  name = "${local.project}-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}



resource "aws_security_group" "ecs" {
  name        = "${local.project}-ecs-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}



