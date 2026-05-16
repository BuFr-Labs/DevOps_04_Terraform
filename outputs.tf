output "instance_public_ip" {
  description = "Verejna IP adresa nove EC2 instance"
  value       = aws_instance.my_server.public_ip
}

output "ssh_connection_string" {
  description = "Prikaz pro pripojeni pres SSH"
  value       = "ssh -i ./id_ed25519 ec2-user@${aws_instance.my_server.public_ip}"
}