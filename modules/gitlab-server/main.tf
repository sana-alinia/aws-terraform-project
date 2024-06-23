resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = "key-pair"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "private_key" {
  content        = tls_private_key.example.private_key_pem
  filename       = "${path.module}/key-pair.pem"
  file_permission = "0400"
}

resource "local_file" "public_key" {
  content  = tls_private_key.example.public_key_openssh
  filename = "${path.module}/public-key.pub"
  file_permission = "0400"
}

resource "aws_instance" "gitlab_server" {
  depends_on                        = [local_file.private_key]

  subnet_id                         = var.subnet_id
  vpc_security_group_ids            = var.vpc_security_group_ids
  instance_type                     = var.instance_type
  user_data_replace_on_change       = var.user_data_replace_on_change
  ami                               = var.ami
  key_name                          = aws_key_pair.example.key_name

  provisioner "file" {
    source      = "${path.module}/docker-containers.sh"
    destination = "/home/ec2-user/docker-containers.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.private_key.filename)
      host        = self.public_ip
      timeout     = "1m"
    }
  }

  tags = {
    Name = "gitlab_server"
  }
}

resource "aws_eip" "gitlab_eip" {
  vpc      = true
  instance = aws_instance.gitlab_server.id

  tags = {
    Name = "GitlabEIP"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "gitlab_setup" {
  depends_on = [aws_instance.gitlab_server, aws_eip.gitlab_eip]
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(local_file.private_key.filename)
      host        = aws_eip.gitlab_eip.public_ip
      timeout     = "4m"
    }

    inline = [
      "echo 'Starting script execution' > /home/ec2-user/script_log.txt 2>&1",
      "sudo yum update -y && echo 'yum update completed' >> /home/ec2-user/script_log.txt 2>&1",
      "sudo yum install -y docker && echo 'Docker installed' >> /home/ec2-user/script_log.txt 2>&1",
      "sudo service docker start && echo 'Docker service started' >> /home/ec2-user/script_log.txt 2>&1",
      "sudo usermod -aG docker ec2-user && echo 'Added ec2-user to docker group' >> /home/ec2-user/script_log.txt 2>&1",
      "sudo mkdir -p /srv/gitlab/config /srv/gitlab/logs /srv/gitlab/data",
      "sudo docker run --detach --hostname ${aws_instance.gitlab_server.public_ip} --env GITLAB_OMNIBUS_CONFIG=\"external_url 'http://${aws_instance.gitlab_server.public_ip}'\" --publish 443:443 --publish 80:80 --publish 2222:22 --name gitlab --restart always --volume /srv/gitlab/config:/etc/gitlab --volume /srv/gitlab/logs:/var/log/gitlab --volume /srv/gitlab/data:/var/opt/gitlab --shm-size 256m gitlab/gitlab-ce:latest && echo 'GitLab container started' >> /home/ec2-user/script_log.txt 2>&1 || echo 'Failed to start GitLab container' >> /home/ec2-user/script_log.txt 2>&1",
      "chmod +x /home/ec2-user/docker-containers.sh",
      "sudo /home/ec2-user/docker-containers.sh",
      "curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -",
      "sudo yum install -y nodejs",
      "sleep 5",
      "GITLAB_ROOT_PASSWORD=$(sudo docker exec gitlab cat /etc/gitlab/initial_root_password | grep 'Password:' | awk '{print $2}')",
      "echo $GITLAB_ROOT_PASSWORD > /home/ec2-user/gitlab_root_password.txt",
      "JENKINS_ROOT_PASSWORD=$(sudo docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword)",
      "echo $JENKINS_ROOT_PASSWORD > /home/ec2-user/jenkins_root_password.txt",
    ]
  }
  provisioner "local-exec" {
    command = <<EOT
      scp -o StrictHostKeyChecking=no -i /Users/bahram/Documents/repos/aws-terraform-project/modules/gitlab-server/key-pair.pem ec2-user@${aws_instance.gitlab_server.public_ip}:/home/ec2-user/*root_password.txt modules/gitlab-server
    EOT
  }
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "local_file" "gitlab_root_password" {
  filename = "${path.module}/gitlab_root_password.txt"
}

data "local_file" "access_token" {
  filename = "${path.module}/access_token.txt"
}




