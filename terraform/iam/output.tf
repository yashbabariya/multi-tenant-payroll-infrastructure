output "tenant_role_arn" {
  value = aws_iam_role.tenant_role[*].arn
}

output "tenant_role_name" {
  value = aws_iam_role.tenant_role[*].name
}