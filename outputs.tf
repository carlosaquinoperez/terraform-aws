output "bucket_arn" {
  description = "El ARN (Amazon Resource Name) del bucket creado"
  value       = aws_s3_bucket.capa_bronze.arn
}