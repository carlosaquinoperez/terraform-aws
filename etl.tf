# 1. Subimos el script de PySpark a una carpeta "scripts" en tu bucket Bronze
resource "aws_s3_object" "etl_script" {
  bucket = aws_s3_bucket.capas_medallon["bronze"].bucket
  key    = "scripts/job_bronze_to_silver.py"
  source = "job_bronze_to_silver.py" # El archivo local que acabas de crear
  
  # Esto hace que Terraform vuelva a subir el archivo si le haces cambios al código Python
  etag   = filemd5("job_bronze_to_silver.py") 
}

# 2. Creamos el Job de AWS Glue (El clúster Serverless de Spark)
resource "aws_glue_job" "bronze_to_silver_job" {
  name     = "spikio_etl_bronze_to_silver"
  role_arn = aws_iam_role.datalake_role.arn # El mismo gafete que usamos para el Crawler

  # Configuramos la máquina
  glue_version      = "4.0" # Versión moderna de Spark
  worker_type       = "G.1X" # Tamaño de la máquina estándar
  number_of_workers = 2      # Cuántas máquinas trabajarán en paralelo
  timeout           = 15     # Si se traba, que se apague en 15 minutos para no gastar dinero

  command {
    # Le decimos que es un script de Python 3 para Glue
    name            = "glueetl"
    python_version  = "3"
    # Le indicamos exactamente dónde guardamos el script en el paso 1
    script_location = "s3://${aws_s3_bucket.capas_medallon["bronze"].bucket}/${aws_s3_object.etl_script.key}"
  }

  tags = {
    Environment  = "Dev"
    Arquitectura = "Medallon"
  }
}