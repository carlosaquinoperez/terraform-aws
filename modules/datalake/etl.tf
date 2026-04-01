# modules/datalake/etl.tf

resource "aws_s3_object" "etl_script" {
  bucket = aws_s3_bucket.datalake_layers["bronze"].bucket
  key    = "scripts/job_bronze_to_silver.py"
  source = var.etl_script_path
  etag   = filemd5(var.etl_script_path)
}

resource "aws_glue_job" "bronze_to_silver_job" {
  name     = "${var.project_name}_${var.environment}_etl_bronze_to_silver"
  role_arn = aws_iam_role.glue_processor_role.arn

  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = 2
  timeout           = 15

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "s3://${aws_s3_bucket.datalake_layers["bronze"].bucket}/${aws_s3_object.etl_script.key}"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}