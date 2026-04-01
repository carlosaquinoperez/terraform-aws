# modules/datalake/iam.tf

# ------------------------------------------------------------------------------
# IAM: SECURITY & ACCESS CONTROL
# ------------------------------------------------------------------------------

resource "aws_iam_role" "glue_processor_role" {
  # Dynamic naming to prevent collisions
  name = "${var.project_name}-${var.environment}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "datalake_access" {
  name        = "${var.project_name}-${var.environment}-datalake-policy"
  description = "Allows Glue to read/write to the ${var.environment} Medallion Data Lake"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Effect = "Allow"
      Resource = [
        "arn:aws:s3:::${var.project_name}-${var.environment}-*-layer",
        "arn:aws:s3:::${var.project_name}-${var.environment}-*-layer/*"
      ]
    }]
  })
}

# Attach our custom policy to the role
resource "aws_iam_role_policy_attachment" "datalake_custom_attach" {
  role       = aws_iam_role.glue_processor_role.name
  policy_arn = aws_iam_policy.datalake_access.arn
}

# Attach AWS managed policy for Glue core permissions
resource "aws_iam_role_policy_attachment" "glue_service_attach" {
  role       = aws_iam_role.glue_processor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}