resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/events/${local.resource_name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_document = data.aws_iam_policy_document.this.json
  policy_name     = "${local.resource_name}-ecs-events"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*:*"]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_cloudwatch_event_rule.cluster_events.arn,
        aws_cloudwatch_event_rule.deployment_events.arn,
      ]
    }
  }
}
