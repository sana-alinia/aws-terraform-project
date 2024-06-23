output "gitlab_server_ip" {
  value = module.gitlab-server.gitlab_server_ip
}

output "instance_id" {
  value = module.gitlab-server.instance_id
}

output "instance_public_ip" {
  value = module.gitlab-server.instance_public_ip
}

output "public_ip" {
  value = module.gitlab-server.public_ip
}

output "region" {
  description = "AWS region"
  value       = module.gitlab-server.region
}

output "subnet_ids" {
  value = module.gitlab-server.subnet_ids
}

output "gitlab_root_password" {
  value = module.gitlab-server.gitlab_root_password
}

output "gitlab_access_token" {
  value = module.gitlab-server.gitlab_access_token
}