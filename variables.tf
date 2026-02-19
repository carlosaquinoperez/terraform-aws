variable "region" {
  description = "Región de AWS donde desplegaremos todo"
  type        = string
  default     = "us-east-1"
}

variable "nombre_bucket_bronze" {
  description = "Nombre único para el bucket de datos crudos"
  type        = string
  default     = "carlos-data-bronze-2026"
}