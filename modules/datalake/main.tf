# modules/datalake/main.tf

# ------------------------------------------------------------------------------
# S3 BUCKETS: MEDALLION ARCHITECTURE
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "datalake_layers" {
  for_each = var.datalake_layers

  # Dynamic naming convention: project-environment-layer-suffix
  bucket = "${var.project_name}-${var.environment}-${each.key}-layer"

  # Standardized resource tagging
  tags = {
    Name         = "${title(var.project_name)} ${title(var.environment)} ${title(each.key)} Layer"
    Environment  = var.environment
    Project      = var.project_name
    Architecture = "Medallion"
    Layer        = each.key
    ManagedBy    = "Terraform"
  }
}