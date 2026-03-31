# Enterprise Data Lakehouse Architecture for Spikio

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Apache Spark](https://img.shields.io/badge/apache_spark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

---

## 📌 Project Overview

This repository contains the Infrastructure as Code (IaC) and Data Engineering pipelines required to deploy a fully automated, serverless Data Lakehouse for **[spikio.app](https://spikio.app)** — an AI-driven English learning platform via WhatsApp.

The goal of this project is to securely ingest, process, and catalog millions of WhatsApp chat interactions, transforming raw JSON data into highly optimized Parquet format for analytics and Machine Learning, using AWS native services and PySpark.

---

## 🏗️ Architecture Design

The project implements a **Medallion Architecture** (Bronze → Silver → Gold) entirely provisioned via Terraform.

### Layers

| Layer | Service | Description |
|---|---|---|
| **Storage** | Amazon S3 | Medallion buckets: Bronze (raw JSON), Silver (clean Parquet), Gold (aggregated Data Marts) |
| **Security** | AWS IAM | Least-privilege roles and policies for machine identities (AWS Glue) |
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

## 📁 Repository Structure

```text
├── .github/workflows/
│   ├── terraform.yml           # CI/CD Pipeline for Apply
│   └── terraform-destroy.yml   # Manual Pipeline for Destroy
├── etl.tf                      # AWS Glue Job provisioning
├── glue.tf                     # AWS Glue Catalog & Crawlers
├── iam.tf                      # Roles and Policies for secure access
├── main.tf                     # S3 Buckets creation (Medallion Architecture)
├── variables.tf                # Terraform variables
├── outputs.tf                  # Terraform outputs
├── job_bronze_to_silver.py     # PySpark ETL script
└── README.md                   # Project documentation
```

---

## 🛠️ How to Deploy

### Prerequisites

1. An active **AWS Account**.
2. The following **GitHub Repository Secrets** configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. A pre-created **S3 bucket** for the Terraform backend (defined in `main.tf`).

### Deployment Steps

1. Make changes to `.tf` files or the PySpark ETL script (`.py`).
2. Commit and push to the `main` branch:

```bash
git add .
git commit -m "feat: updating data pipelines"
git push origin main
```

3. **GitHub Actions** will automatically provision the infrastructure and upload the latest ETL script to AWS.
4. To run the ETL manually, navigate to the **AWS Glue Console**, select the job `spikio_etl_bronze_to_silver`, and click **Run**.

---

## 🧹 FinOps & Teardown

To prevent incurring AWS charges when the development environment is not in use:

1. Go to the **Actions** tab in your GitHub repository.
2. Select the **`Terraform DESTROY (Peligro ⚠️)`** workflow.
3. Click **Run workflow**.

This will execute `terraform destroy` and cleanly remove all provisioned cloud resources.

---

## 👤 Author

**Carlos Aquino Pérez** — Senior Data Engineer