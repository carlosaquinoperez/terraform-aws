variable "region" {
  description = "Región de AWS donde desplegaremos todo"
  type        = string
  default     = "us-east-1"
}

variable "capas_datalake" {
  description = "Las capas de la arquitectura medallón"
  type        = set(string)
  default     = ["bronze", "silver", "gold"]
}