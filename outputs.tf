output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| The name of the Cloudwatch log group containing an export of ECS events"
}
