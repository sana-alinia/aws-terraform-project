output "project_id" {
  description = "The ID of the GitLab project"
  value       = gitlab_project.project.id
}

output "project_url" {
  description = "The URL of the GitLab project"
  value       = gitlab_project.project.web_url
}
