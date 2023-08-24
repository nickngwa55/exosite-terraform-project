resource "aws_instance" "nginx_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI - ensure this is the latest in us-west-2
  instance_type = "t4g.nano"

  key_name   = "your-key-name"  # Replace with your key name
  subnet_id  = local.subnet_ids[0]  # Using the first subnet

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    "Name"  = "nginx-instance"
    "Owner" = "nickngwa"
  }
}
