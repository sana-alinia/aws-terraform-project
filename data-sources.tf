data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "local_file" "root_password" {
  filename = "${path.module}/root_password.txt"
}

data "local_file" "access_token" {
  filename = "${path.module}/access_token.txt"
}
