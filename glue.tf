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

# Creamos el Crawler para la capa Bronze
resource "aws_glue_crawler" "bronze_crawler" {
  name          = "spikio_bronze_crawler"
  
  # Le ponemos el gafete de seguridad que creamos en iam.tf
  role          = aws_iam_role.datalake_role.arn
  
  # Le decimos en qué base de datos guardar los resultados
  database_name = aws_glue_catalog_database.datalake_dbs["bronze"].name

  # Le decimos a dónde tiene que ir a leer los datos físicos
  s3_target {
    path = "s3://${aws_s3_bucket.capas_medallon["bronze"].bucket}/data/"
  }

  tags = {
    Environment  = "Dev"
    Arquitectura = "Medallon"
    Capa         = "bronze"
  }
}

# Creamos el Crawler para la capa Silver
resource "aws_glue_crawler" "silver_crawler" {
  name          = "spikio_silver_crawler"
  
  # Reutilizamos el mismo gafete de seguridad
  role          = aws_iam_role.datalake_role.arn
  
  # Lo conectamos a la base de datos Silver
  database_name = aws_glue_catalog_database.datalake_dbs["silver"].name

  # Apuntamos a la carpeta de datos de la capa Silver
  s3_target {
    path = "s3://${aws_s3_bucket.capas_medallon["silver"].bucket}/data/"
  }

  tags = {
    Environment  = "Dev"
    Arquitectura = "Medallon"
    Capa         = "silver"
  }
}