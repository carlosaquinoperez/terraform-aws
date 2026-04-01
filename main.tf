# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "spikio-tfstate-2026"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "spikio_datalake_dev" {
  source          = "./modules/datalake"
  
  project_name    = "spikio"
  environment     = "dev"
  etl_script_path = "./job_bronze_to_silver.py"
}