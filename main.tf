terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }
  backend "s3" {
    bucket         = "devops-tf-id"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "lambda-tf-state"
  }

  required_version = ">= 1.5.6"
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "hr-tf"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

data "archive_file" "lambda_hr_archive" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/src.zip"
  excludes = [
    "env_tf",
    "*terraform/*",
    "**.terraform/",
    "**.terraform.lock.hcl",
    ".terraform/*",
    ".terraform/*",
    "*/.terraform/*",
    ".terraform/",
    ".terraformignore"
  ]

}

resource "aws_s3_object" "lambda_hr_s3" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "src.zip"
  source = data.archive_file.lambda_hr_archive.output_path
  etag   = filemd5(data.archive_file.lambda_hr_archive.output_path)
}

resource "aws_lambda_function" "hr_pipeline_function_test" {

  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_hr_s3.key
  function_name = "prescreen-interview"
  handler       = "lambda_function.handler"
  runtime       = "python3.9"
  timeout       = 60
  memory_size   = 128


  environment {

    variables = {
      DB       = var.lambda_environments.db
      USERNAME = var.lambda_environments.user
      PASSWORD = var.lambda_environments.pass
    }

  }
  source_code_hash = data.archive_file.lambda_hr_archive.output_base64sha256
  role             = var.aws_iam_role

}

resource "aws_cloudwatch_log_group" "hr_pipeline" {
  name              = "/aws/lambda/${aws_lambda_function.hr_pipeline_function_test.function_name}"
  retention_in_days = 30
}
