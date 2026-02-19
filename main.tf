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

resource "aws_s3_bucket" "capa_bronze" {
  bucket = var.nombre_bucket_bronze

  tags = {
    Name        = "Data Lake Bronze"
    Environment = "Dev"
    Project     = "Curso Terraform" # Mencionando tu startup ;)
  }
}