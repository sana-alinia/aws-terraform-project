````markdown
# AWS CI/CD Pipeline Deployment with Terraform

## Overview

This project aims to deploy a complete CI/CD pipeline in AWS using Terraform. The pipeline integrates several tools including GitLab, SonarQube, Jenkins, Grafana, and Nexus, and automates the deployment of a simple "Hello World" Node.js application. The infrastructure is managed as code using Terraform, ensuring consistent and repeatable deployments.

## Project Structure

```bash
├── data-sources.tf
├── helm
│   └── gitlab-values.yaml
├── k8s
│   ├── grafana
│   │   ├── grafana-deployment.yaml
│   │   └── values.yaml
│   ├── nexus
│   │   ├── nexus-deployment.yaml
│   │   └── values.yaml
│   └── sonarqube
│       ├── sonarqube-deployment.yaml
│       └── values.yaml
├── key_pair.tf
├── main.tf
├── modules
│   └── gitlab-server
│       ├── docker-containers.sh
│       ├── main.tf
│       ├── output.tf
│       ├── public-key.pub
│       └── variables.tf
├── output.tf
├── print-code.py
├── security-group.tf
├── subnet.tf
└── variables.tf
```
````

## Components

### Infrastructure

- **VPC**: Default VPC for isolated network environment.
- **Subnets**: Three public subnets for high availability across different availability zones.
- **Security Groups**: Configured for access control and traffic management.
- **EC2 Instances**: Hosts for GitLab, Jenkins, and Nexus.
- **Kubernetes**: Manages deployments for SonarQube, Grafana, and Nexus using Helm charts.

### Tools

- **GitLab**: Version control and CI/CD management.
- **Jenkins**: Continuous integration and deployment.
- **SonarQube**: Code quality analysis.
- **Nexus**: Artifact repository management.
- **Grafana**: Monitoring and observability.

## Getting Started

### Prerequisites

- AWS account with appropriate permissions.
- Terraform installed on your local machine.
- SSH key pair for accessing EC2 instances.
- GitLab personal access token.

### Configuration

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Configure AWS and GitLab tokens:**

   Ensure you have your AWS credentials and GitLab personal access token ready. Update the `variables.tf` file with your token path:

   ```hcl
   variable "gitlab_token_path" {
     description = "The path to the file containing the GitLab personal access token"
     type        = string
     default     = "/path/to/your/gitlab/token"
   }
   ```

3. **Modify `gitlab-values.yaml`:**

   Update the `helm/gitlab-values.yaml` file with your domain and AWS ACM certificate ARN if applicable:

   ```yaml
   global:
     hosts:
       domain: gitlab.yourdomain.com
     ingress:
       configureCertmanager: false
       annotations:
         kubernetes.io/ingress.class: nginx
       class: "nginx"
       tls:
         enabled: true
         secretName: gitlab-cert
         annotations:
           service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "your-acm-certificate-arn"
   ```

### Deployment

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Apply Terraform configuration:**

   ```bash
   terraform apply
   ```

   Confirm the apply action by typing `yes` when prompted. This will provision the necessary infrastructure and deploy the CI/CD tools.

### Outputs

After successful deployment, Terraform will output essential information such as:

- GitLab server IP address
- Instance IDs and public IPs
- AWS region
- Subnet IDs
- GitLab root password
- Jenkins root password

These outputs can be found in the `output.tf` file and will be displayed in the terminal.

## Challenges and Solutions

### Challenges

- **Resource Dependencies**: Managing the order of resource creation.
- **Networking Issues**: Configuring subnets and security groups.
- **Integration Issues**: Ensuring seamless operation of all tools.
- **Provisioning Delays**: Long setup times for instances and Kubernetes.

### Solutions

- **Resource Dependencies**: Used Terraform's `depends_on` to manage order.
- **Networking Issues**: Carefully planned subnet CIDR blocks and security group rules.
- **Integration Issues**: Thorough testing and configuration adjustments.
- **Provisioning Delays**: Used optimized AMIs and efficient provisioning scripts.

## Conclusion

This project successfully deploys a CI/CD pipeline in AWS using Terraform, integrating GitLab, Jenkins, SonarQube, Nexus, and Grafana. The setup automates the deployment process, improves code quality, and provides comprehensive monitoring. Future improvements could include further automation and scaling enhancements.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
