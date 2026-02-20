terraform {
  backend "s3" {
    bucket = "spikio-tfstate-2026"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

# UN SOLO BLOQUE PARA CREAR MULTIPLES BUCKETS
resource "aws_s3_bucket" "capas_medallon" {
  for_each = var.capas_datalake

  # El nombre final será algo como: datalake-bronze-2026
  bucket = "datalake-${each.key}-2026"

  tags = {
    Name        = "Capa ${each.key}"
    Environment = "Dev"
    Arquitectura = "Medallon"
  }
}