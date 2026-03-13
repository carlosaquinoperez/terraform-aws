# glue.tf

# Creamos las Bases de Datos Lógicas en el Catálogo de Glue
resource "aws_glue_catalog_database" "datalake_dbs" {
  # Reutilizamos tu lista ["bronze", "silver", "gold"]
  for_each = var.capas_datalake

  # El nombre de la base de datos será algo como: spikio_bronze_db
  name        = "spikio_${each.key}_db"
  description = "Base de datos logica para la capa ${each.key} del Data Lake"

  # Le decimos a Glue en qué bucket de S3 viven los datos de esta base de datos
  # Usamos el diccionario de buckets que creamos en main.tf
  location_uri = "s3://${aws_s3_bucket.capas_medallon[each.key].bucket}/"

  tags = {
    Environment  = "Dev"
    Arquitectura = "Medallon"
    Capa         = each.key
  }
}