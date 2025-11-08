provider "aws" {

}

resource "aws_lambda_function" "lambda_function" {
  function_name = "lambda_function_event_trigger"
  runtime = "python3.9"
  role = aws_iam_role.IAM.arn
  handler = "lambda_function.lambda_handler"
  timeout = 900
  memory_size = 128

  filename = "lambda_function.zip"
    source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_iam_role" "IAM" {

    name = "lambda_exec_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
  
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.IAM.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# 4️⃣ Create EventBridge rule (schedule)
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Trigger Lambda every 5 minutes"
#   schedule_expression = "rate(5 minutes)"
  schedule_expression = "cron(0/5 * * * ? *)"

}

# 5️⃣ Add the Lambda target
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda_function.arn
}

# 6️⃣ Allow EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}