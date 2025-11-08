provider "aws" {
  
}

resource "aws_s3_bucket" "createS3" {
    
  bucket = "ashwin.28111994"
  tags = {
    Name = "MyDemoBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.createS3.bucket
  key    = "lambda_function.zip"
  source = "lambda_function.zip"    # this file should exist locally
  etag   = filemd5("lambda_function.zip")
}

resource "aws_iam_role" "iam" {

    name = "LambdaS3"
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

resource "aws_iam_role_policy_attachment" "attach_policy" {
    role       = aws_iam_role.iam.name
    policy_arn = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  
}

resource "aws_lambda_function" "lambda" {
    function_name = "my_Lambda_Function1"
    role = aws_iam_role.iam.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    timeout = 900
    memory_size = 128
  
    # Code from S3 bucket instead of local file
  s3_bucket = aws_s3_bucket.createS3.bucket
  s3_key    = aws_s3_object.lambda_zip.key
}