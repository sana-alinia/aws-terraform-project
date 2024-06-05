terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">= 3.11.0"
    }
  }
}

provider "gitlab" {
  base_url = var.gitlab_base_url
  token    = "glpat--9dwHM_ifMmfjMHf_F-p" // file(var.gitlab_token_path)
}

resource "gitlab_project" "project" {
  name             = var.project_name
  description      = var.project_description
  visibility_level = var.visibility_level
}

resource "gitlab_project_variable" "repository_url" {
  project = gitlab_project.project.id
  key     = "REPOSITORY_URL"
  value   = var.repository_url
}
