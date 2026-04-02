# Enterprise Data Lakehouse Architecture for Spikio

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Apache Spark](https://img.shields.io/badge/apache_spark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

---

## 📌 Project Overview

This repository contains the Infrastructure as Code (IaC) and Data Engineering pipelines required to deploy a fully automated, serverless Data Lakehouse for **[spikio.app](https://spikio.app)** — an AI-driven English learning platform via WhatsApp.

The goal of this project is to securely ingest, process, and catalog millions of WhatsApp chat interactions, transforming raw JSON data into highly optimized Parquet format for analytics and Machine Learning. The architecture is designed as a **Reusable Terraform Module**, allowing seamless and isolated deployments across multiple environments (Dev, QA, Prod) with dynamic resource naming.

---

## 🏗️ Architecture Design

The project implements a **Medallion Architecture** (Bronze → Silver → Gold) entirely provisioned via Terraform.

### Layers & Services

| Layer | Service | Description |
|---|---|---|
| **Storage** | Amazon S3 | Medallion buckets: Bronze (raw JSON), Silver (clean Parquet), Gold (aggregated Data Marts) |
| **Security** | AWS IAM | Environment-isolated, least-privilege roles for machine identities |
| **Data Catalog** | AWS Glue Catalog & Crawler | Automated schema discovery and metadata management |
| **Compute & ETL** | AWS Glue + PySpark | Serverless distributed data processing |
| **Query Engine** | Amazon Athena | Ad-hoc serverless SQL querying over S3 data |

### S3 Medallion Buckets

- 🥉 **Bronze** — Raw JSON data from WhatsApp interactions, partitioned by ingestion date.
- 🥈 **Silver** — Cleaned and schema-enforced data stored in optimized Parquet format.
- 🥇 **Gold** — Aggregated business-level data (Data Marts) ready for BI and ML consumption.

---

## 🚀 CI/CD Pipeline (GitOps)

All infrastructure and ETL scripts are deployed automatically using **GitHub Actions**.

| Workflow | Trigger | Description |
|---|---|---|
| `terraform.yml` | Push to `main` | Runs `terraform init` → `plan` → `apply -auto-approve` |
| `terraform-destroy.yml` | Manual (FinOps) | Tears down all infrastructure to avoid unnecessary cloud costs |

> **Remote State:** Terraform state is safely managed in a dedicated S3 backend (`spikio-tfstate-2026`).

---

## 📁 Repository Structure (Modular Design)

The infrastructure is separated into a reusable factory (`modules/datalake`) and a root client configuration, keeping business logic (Python) completely decoupled from the IaC.

```text
├── .github/workflows/
│   ├── terraform.yml           # CI/CD Pipeline for Apply
│   └── terraform-destroy.yml   # Manual Pipeline for Destroy
├── modules/datalake/           # 📦 Reusable Terraform Module (The Factory)
│   ├── etl.tf                  # Glue Jobs provisioning
│   ├── glue.tf                 # Data Catalog & Crawlers
│   ├── iam.tf                  # Isolated Roles and Policies
│   ├── main.tf                 # Medallion S3 Buckets
│   └── variables.tf            # Module parameters (Project, Env, etc.)
├── ingesta_bronze.py           # Mock ingestion script
├── job_bronze_to_silver.py     # PySpark ETL script (Business Logic)
├── main.tf                     # Root client invoking the datalake module
└── README.md                   # Project documentation
```

---

## 🛠️ How to Deploy

### Prerequisites

1. An active **AWS Account**.
2. The following **GitHub Repository Secrets** configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. A pre-created **S3 bucket** for the Terraform backend (defined in root `main.tf`).

### Deployment Steps

1. To deploy to a different environment, adjust the `environment` variable in the root `main.tf`:

```hcl
module "spikio_datalake_dev" {
  source          = "./modules/datalake"
  project_name    = "spikio"
  environment     = "dev" # Change to "qa" or "prod" as needed
  etl_script_path = "./job_bronze_to_silver.py"
}
```

2. Commit and push your changes to the `main` branch:

```bash
git add .
git commit -m "feat: infrastructure updates"
git push origin main
```

3. **GitHub Actions** will automatically provision the isolated infrastructure and upload the latest ETL script to AWS.

4. To run the ETL manually, navigate to the **AWS Glue Console**, select the generated job (e.g., `spikio_dev_etl_bronze_to_silver`), and click **Run**.

---

## 🧹 FinOps & Teardown

To prevent incurring AWS charges when the development environment is not in use:

1. Go to the **Actions** tab in your GitHub repository.
2. Select the **`Terraform DESTROY (Peligro ⚠️)`** workflow.
3. Click **Run workflow**.

This will execute `terraform destroy` and cleanly remove all provisioned cloud resources for that specific environment.

---

## 👤 Author

**Carlos Aquino Pérez** — Senior Data Engineer