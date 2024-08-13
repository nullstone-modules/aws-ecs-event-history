resource "aws_cloudwatch_event_rule" "cluster_events" {
  name        = "${local.resource_name}-cluster-events"
  description = "Capture ECS container instance and task state changes for a specific ECS cluster"

  event_pattern = jsonencode({
    "source" : [
      "aws.ecs"
    ],
    "detail-type" : [
      "ECS Container Instance State Change",
      "ECS Task State Change"
    ],
    "detail" : {
      "clusterArn" : [local.cluster_arn]
    }
  })
}

resource "aws_cloudwatch_event_rule" "deployment_events" {
  name        = "${local.resource_name}-deployment-events"
  description = "Capture ECS deployment state changes"

  event_pattern = jsonencode({
    "source" : [
      "aws.ecs"
    ],
    "detail-type" : [
      "ECS Deployment State Change"
    ]
  })
}

resource "aws_cloudwatch_event_target" "cluster_events_to_logs" {
  rule = aws_cloudwatch_event_rule.cluster_events.name
  arn  = aws_cloudwatch_log_group.this.arn
}

resource "aws_cloudwatch_event_target" "deployment_events_to_logs" {
  rule = aws_cloudwatch_event_rule.deployment_events.name
  arn  = aws_cloudwatch_log_group.this.arn
}
