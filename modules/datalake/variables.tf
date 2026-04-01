# modules/datalake/variables.tf

variable "project_name" {
  description = "The name of the project (e.g., spikio)"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, qa, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "datalake_layers" {
  description = "Set of layers for the Medallion Architecture"
  type        = set(string)
  default     = ["bronze", "silver", "gold"]
}

variable "etl_script_path" {
  description = "Path to the PySpark ETL script"
  type        = string
}