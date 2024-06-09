terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">= 3.11.0"
    }
  }
}

module "gitlab_project" {
  source              = "./modules/gitlab"
  gitlab_base_url     = "https://${aws_eip.gitlab_eip.public_ip}/api/v4"
  gitlab_token_path   = "${path.module}/access_token.txt"
  project_name        = "aws-terraform-project"
  project_description = "An example project created using Terraform"
  visibility_level    = "public"
  repository_url      = "https://github.com/sanafe/notes-app-cicd"
  count               = var.use_module_gitlab ? 1 : 0
}

provider "gitlab" {
  # base_url = var.gitlab_base_url
  token    = file(var.gitlab_token_path)
}

resource "gitlab_project" "project" {
  name             = var.project_name
  description      = var.project_description
  visibility_level = var.visibility_level
  count            = var.use_module_gitlab ? 1 : 0
}

resource "gitlab_project_variable" "repository_url" {
  project = gitlab_project.project.id
  key     = "REPOSITORY_URL"
  value   = var.repository_url
  count   = var.use_module_gitlab ? 1 : 0
}
