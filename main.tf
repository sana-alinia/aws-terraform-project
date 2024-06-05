terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">= 3.11.0"
    }
  }
  required_version = "~> 1.3"
}

provider "aws" {
  region = var.region
}

provider "gitlab" {
  base_url = var.gitlab_base_url
  token    = file(var.gitlab_token_path)
}

locals {
  gitlab_base_url = "https://${aws_eip.gitlab_eip.public_ip}/api/v4"
}

module "gitlab_project" {
  source              = "./modules/gitlab"
  gitlab_base_url     = "https://${aws_eip.gitlab_eip.public_ip}/api/v4"
  gitlab_token_path   = "${path.module}/access_token.txt"
  project_name        = "aws-terraform-project"
  project_description = "An example project created using Terraform"
  visibility_level    = "public"
  repository_url      = "https://github.com/sanafe/notes-app-cicd"
}

output "project_id" {
  value = module.gitlab_project.project_id
}

output "project_url" {
  value = module.gitlab_project.project_url
}

