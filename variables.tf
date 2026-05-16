variable "aws_region" {
  description = "AWS region pro nasazeni infrastruktury"
  type        = string
  default     = "eu-central-1" 
}

variable "instance_type" {
  description = "Typ EC2 instance"
  type        = string
  default     = "t3.micro"
}