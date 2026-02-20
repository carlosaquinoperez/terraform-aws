output "nombres_de_buckets" {
  description = "Nombres de los buckets creados para el Data Lake"
  # Iteramos sobre los recursos creados para extraer solo el nombre (id)
  value       = [for bucket in aws_s3_bucket.capas_medallon : bucket.id]
}