output "allocation_id" {
  description = "Elastic IP Allocation ID"
  value       = aws_eip.this.id
}

output "public_ip" {
  description = "Elastic IP Address"
  value       = aws_eip.this.public_ip
}