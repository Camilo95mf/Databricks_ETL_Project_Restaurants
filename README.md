
# Restaurants Insight ETL Pipeline

A production-grade, end-to-end ETL pipeline built on Databricks utilizing the **Medallion Architecture** to deliver high-quality, analytics-ready restaurant data. This project leverages **Structured Data Pipelines (SDP / Streaming Tables)** for continuous or batch data manipulation across stages and is fully orchestrated and packaged using **Declaratrive Automation Bundle (DABs)**.

This project was built using SQL as the main language.

---

## 🏗️ Architecture Overview

The data flows through three distinct stages of the Medallion Architecture to ensure strict data quality, governance, and optimized performance:

## ⚙️ Core Technologies & Design Standards

*   **Declaratrive Automation Bundle (DABs):** Used to bundle all code, configuration files, pipelines, and workflows into a single deployable artifact. This ensures strict CI/CD alignment and environment consistency (Dev, QA, Prod).
*   **Spark Declarative Pipelines (SDP):** Built using Streaming Tables or declarative streaming syntax to handle seamless multi-stage data manipulation with built-in quality rules (Expectations).
*   **Automated Orchestration:** An integrated Databricks Job manages the end-to-end execution of the pipelines, handling task dependencies, cluster management, and alerting.

---

## 📁 Repository Structure

```text
├── databricks.yml           # Databricks Asset Bundle (DAB) configuration file
├── bundle.json              # Generated bundle constraints
├── src/                     # Source code directory
│   ├── bronze/              # Pipelines for data ingestion
│   ├── silver/              # Pipelines for cleaning, filtering, and refining
│   └── gold/                # Business logic, metrics, and consumption layers
├── resources/               # Job definitions, SDP pipeline configurations, and schedules
└── README.md                # Project documentation
```


## Getting started

1. Install the Databricks CLI from https://docs.databricks.com/dev-tools/cli/install.html

2. Authenticate to your Databricks workspace (if you have not done so already):
    ```
    $ databricks configure
    ```

3. To deploy a development copy of this project, type:
    ```
    $ databricks bundle deploy --target dev
    ```
    (Note that "dev" is the default target, so the `--target` parameter
    is optional here.)

    This deploys everything that's defined for this project.
    For example, the default template would deploy a job called
    `[dev yourname] restaurants_insight_job` to your workspace.
    You can find that job by opening your workpace and clicking on **Jobs & Pipelines**.

4. Similarly, to deploy a production copy, type:
   ```
   $ databricks bundle deploy --target prod
   ```

5. To run a job, use the "run" command:
   ```
   $ databricks bundle run
   ```

6. Optionally, install developer tools such as the Databricks extension for Visual Studio Code from
   https://docs.databricks.com/dev-tools/vscode-ext.html.

7. For documentation on the Declarative Automation Bundles format used
   for this project, and for CI/CD configuration, see
   https://docs.databricks.com/dev-tools/bundles/index.html.

## Changing the warehouse, catalog, or schema

The default SQL warehouse, catalog, and schema are configured in `databricks.yml`.
To change these settings, edit the `variables` section for each target (dev/prod).
