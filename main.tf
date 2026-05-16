terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Vyhledání nejnovějšího Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true                # seřadí podle data vydání
  owners      = ["amazon"]          # v úvahu bere jen officiální image od Amazonu

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]   # hledá název začínající na al2023-ami-2023 a končící x86_64
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]             # x86 architektura
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Vytvoření Security Groupy pro SSH
resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh_from_internet"
  description = "Povoli SSH pristup na portu 22"

  # Příchozí pravidlo (Inbound)
  ingress {
    description = "SSH z internetu"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Odchozí pravidlo (Outbound)
  egress {
    description = "Povoleni odchoziho provozu ze serveru do internetu"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"              # jakykoliv protokol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-task-04-sg"
  }
}


# 1. Nahrání veřejného SSH klíče do AWS
resource "aws_key_pair" "my_ssh_key" {
  key_name   = "devops-task-04-key"
  public_key = file("./id_ed25519.pub")
}

# 2. Vytvoření samotné EC2 instance
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.amazon_linux_2023.id         # Bere ID z data bloku
  instance_type = var.instance_type                         # Bere typ z variables.tf
  key_name      = aws_key_pair.my_ssh_key.key_name          # Přiřadí SSH klíč

  # Přiřazení naší Security Group pro povolení portu 22
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "DevOps-Task-04-Instance"
  }
}