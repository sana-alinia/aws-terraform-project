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
  # base_url = var.gitlab_base_url
  token    = file(var.gitlab_token_path)
}

module "gitlab-server" {
  ami                                 = "ami-052984d1804039ba8"
  source                              = "./modules/gitlab-server"
  instance_type                       = "t3.large" // "t2.micro"
  user_data_replace_on_change         = true
  vpc_security_group_ids              = [aws_security_group.gitlab_sg.id, aws_security_group.allow_docker_ports.id]
  subnet_id                           = element(data.aws_subnets.default.ids, 0)

}

# locals {
#   gitlab_base_url = "https://${aws_eip.gitlab_eip.public_ip}/api/v4"
# }

# output "project_id" {
#   value = module.gitlab_project.project_id
# }

# output "project_url" {
#   value = module.gitlab_project.project_url
# }

