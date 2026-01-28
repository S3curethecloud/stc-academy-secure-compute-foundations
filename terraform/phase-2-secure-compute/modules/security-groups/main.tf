# App Security Group (Private Compute)
resource "aws_security_group" "app" {
  name   = "stc-p2-sg-app"
  vpc_id = var.vpc_id

  ingress {
    description = "No inbound by default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stc-p2-sg-app"
  }
}
