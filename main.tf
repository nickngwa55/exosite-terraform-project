terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    version = "5.12.0" }
  }
  # The s3 state backend is already set up under `exosite-temporary-tfstate`  
  backend "s3" {
    bucket         = "exosite-temporary-tfstate"
    key            = "nickngwa/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "tflock"
  }
}
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      "Owner" = "nickngwa"
    }
  }
}

resource "aws_security_group" "lb_sg" {

  name = "load-balancer-sg"

  description = "Allow incoming traffic on port 80 and 443"

  vpc_id = local.vpc_id


  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {

    "Name" = "load-balancer-sg"

    "Owner" = "nickngwa"

  }

}

resource "aws_lb" "nginx_lb" {
  name                       = "nginx-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = local.subnet_ids
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  tags = {
    "Name"  = "nginx-lb"
    "Owner" = "nickngwa"
  }
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nginx_tg_attachment" {
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx_instance.id
  port             = 80
}

resource "aws_instance" "nginx_instance" {
  ami           = "ami-08f636ee366a58ec8" # Amazon Linux 2 AMI - ensure this is the latest in us-west-2
  instance_type = "t4g.nano"
  subnet_id     = local.subnet_ids[0] # Using the first subnet

  user_data = <<-EOF
              #!/bin/bash
             sudo yum update -y
             sudo yum install nginx -y 
             sudo service start nginx
              EOF

  tags = {
    "Name"  = "nginx-instance"
    "Owner" = "nickngwa"
  }
}


# Some useful values from the environment
locals {
  vpc_id = "vpc-0c2a36846ba20e729"
  subnet_ids = [
    "subnet-0068679226e81966f",
    "subnet-0db7119e20b440c97",
    "subnet-056f4097e702e48ac",
    "subnet-07c4289662cca87e6"
  ]
  domain_name = "nickngwa.interview.exosite.biz"
  zone_id     = "Z0900350IRBV4VB1AT02"
} 
