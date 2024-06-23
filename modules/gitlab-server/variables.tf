variable region {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable public_key_path {
  description = "Path to the public key to be used for the AWS key pair"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable private_key_path {
  description = "Path to the private key file for SSH access"
  type        = string
  default     = "./key-pair.pem"
}

variable gitlab_hostname {
  description = "Host name for GitLab"
  default     = "gitlab.aliniacoding.com"
}

variable gitlab_base_url {
  description = "The base URL of the GitLab instance"
  type        = string
  default     = "ttps://13.36.144.156/api/v4/user"
}

variable gitlab_token_path {
  description = "The path to the file containing the GitLab personal access token"
  type        = string
  default     = ""
}

variable project_name {
  description = "The name of the GitLab project"
  type        = string
  default     = "aws-terraform-project"
}

variable project_description {
  description = "The description of the GitLab project"
  type        = string
  default     = "Test project for aws terraform"
}

variable visibility_level {
  description = "The visibility level of the GitLab project"
  type        = string
  default     = "public"
}

variable repository_url {
  description = "The URL of the remote repository to be added to the project"
  type        = string
  default     = "https://github.com/sanafe/notes-app-cicd"
}

variable ami {
  description = "amazon machine identifier"
  type        = string
  default     = "ami-052984d1804039ba8"
} 

variable instance_type {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
} 

variable user_data_replace_on_change {
  description = "recreate when user data is changed"
  type        = bool
  default     = false
} 

variable vpc_security_group_ids {
  description = "security group ids of default vpc"
  type        = list
}

variable subnet_id {
  description = "The ID of the subnet to use"
  type        = string
}



