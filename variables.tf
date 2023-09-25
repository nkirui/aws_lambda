variable "aws_region" {
  description = "AWS region for my DEVOPS"

  type    = string
  default = "us-east-1"
}

variable "aws_iam_role" {

  description = "Store Aws ROle ID"
  type        = string
  sensitive   = true
  default     = "TF_VAR_aws_iam_role"
}

variable "lambda_environments" {
  description = "Store lambda environments"
  type        = map(string)
  default = {
    db   = "TF_VAR_db"
    user = "TF_VAR_user"
    pass = "TF_VAR_password"
  }
  sensitive = true

}