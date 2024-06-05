variable "gitlab_base_url" {
  description = "The base URL of the GitLab instance"
  type        = string
  default     = "https://13.36.144.156/api/v4/user"
}

variable "gitlab_token_path" {
  description = "The path to the file containing the GitLab personal access token"
  type        = string
  default     = "glpat--9dwHM_ifMmfjMHf_F-p"
}

variable "project_name" {
  description = "The name of the GitLab project"
  type        = string
  default     = "aws-terraform-project"
}

variable "project_description" {
  description = "The description of the GitLab project"
  type        = string
  default     = "Test project for aws-terraform"
}

variable "visibility_level" {
  description = "The visibility level of the GitLab project"
  type        = string
  default     = "public"
}

variable "repository_url" {
  description = "The URL of the remote repository to be added to the project"
  type        = string
  default     = "https://github.com/sanafe/notes-app-cicd"
}
