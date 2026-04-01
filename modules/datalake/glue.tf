# modules/datalake/glue.tf

# ------------------------------------------------------------------------------
# DATA CATALOG & CRAWLERS
# ------------------------------------------------------------------------------

resource "aws_glue_catalog_database" "datalake_dbs" {
  for_each = var.datalake_layers

  # Databases require underscores, replacing hyphens
  name         = replace("${var.project_name}_${var.environment}_${each.key}_db", "-", "_")
  description  = "Logical database for the ${each.key} layer in ${var.environment} environment"
  
  # Pointing dynamically to the S3 bucket created in main.tf
  location_uri = "s3://${aws_s3_bucket.datalake_layers[each.key].bucket}/"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Layer       = each.key
    ManagedBy   = "Terraform"
  }
}

resource "aws_glue_crawler" "datalake_crawlers" {
  # We only want crawlers for Bronze and Silver for now
  for_each = toset(["bronze", "silver"])

  name          = "${var.project_name}-${var.environment}-${each.key}-crawler"
  role          = aws_iam_role.glue_processor_role.arn
  database_name = aws_glue_catalog_database.datalake_dbs[each.key].name

  s3_target {
    path = "s3://${aws_s3_bucket.datalake_layers[each.key].bucket}/data/"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Layer       = each.key
    ManagedBy   = "Terraform"
  }
}