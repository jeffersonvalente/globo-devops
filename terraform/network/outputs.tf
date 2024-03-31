output "subnet_id" {
    value = aws_subnet.my_public_subnet.id
}

output "securityGroup_id" {
    value = aws_security_group.my-sg.id
}