# Introduction

Welcome to the Data Control Plane Seed Project

This project aims to provide a starting point for building a Data Control Plane, a centralized platform for managing and governing data across an organization. To achieve this, we're leveraging a suite of popular open-source tools, including:

dbt (Data Build Tool) for data transformation and modeling
Data Contract Manager and datacontract-cli for data governance and contract management
SodaCL Core (and Great Expectations in the roadmap) for data quality and validation
To get started, we're using dbt's Jaffle Shop Seed Data as a foundation for our project. This seed data provides a sample dataset and dbt project that we can use to experiment with and build upon.

The goal of this project is to demonstrate how these tools can be integrated to create a robust Data Control Plane, enabling data teams to manage and govern their data with confidence. We'll be exploring topics such as data transformation, data governance, data quality, and more, and providing examples and tutorials to help you get started with your own Data Control Plane project.

What to Expect

In this project, you'll find:

A dbt project set up with Jaffle Shop Seed Data
Integration with [Data Contract Manager](https://datacontractmanagerpoc.azurewebsites.net/mars) and datacontract-cli for data governance
Integration with SodaCL Core for data quality and validation
Examples and tutorials for using these tools together

We hope this project will serve as a useful starting point for your own Data Control Plane journey. Let's get started!

# Getting Started
## Warehouse Pre-Requisits
Before starting the jaffle-data seed example, we need to establish a Database & Schema in our Warehouses for a sink to land our data. The steps below will create the necessary assets in our warehouses to begin seeding data. Please export the project level environment variables consistent across Warehouses.

### Snowflake
To [Install Snowflake CLI](https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation#install-with-linux-package-managers), follow these steps
```bash
wget https://sfc-repo.snowflakecomputing.com/snowflake-cli/linux_x86_64/3.2.1/snowflake-cli-3.2.1.x86_64.deb
sudo dpkg -i snowflake-cli-3.2.1.x86_64.deb

snow --version
snow connection add
```

Use the following [dbt Snowflake Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) to configure your development machine to allow dbt to interact with your Snowflake instance. Make sure to name the Schema **CONTRACT_FIRST_RAW** to follow along with the examples.

### Databricks

Create a [New Catalog](https://docs.databricks.com/aws/en/data-governance/unity-catalog/get-started#step-5-create-new-catalogs-and-schemas) in Databricks Unity Catalog before beginning. We assume that the maintainers of Unity Catalog for the organization will assist with creating catalog for the purpose of this project.


## DBML Requirements
DBML is a schema type language for defining DB agnostic Schema Definitions. Ensure to register with [dbdiagrams.io](https://dbdiagram.io/), 
and [Install the CLI](https://docs.dbdocs.io/#installation)

```shell
npm install -g dbdocs

dbdocs login
```

## Go Tasks
To simplify the cli inputs and repetition, we're going to leverage Go Tasks to define concise tasks for closely tied together commands grouped by categorical namespaces to make this project easier to deploy locally. You may find installation instructions [Here](https://taskfile.dev/installation/)

Once installed, you can review all the accessible tasks in this project using the following command: `task --list-all`.

# Build and Test

## (Mock) Data Ingestion

To get started with building our Data Control Plane, we'll begin by ingesting data into our dbt project using the Jaffle Shop Seed Data. This seed data provides a sample dataset that we can use to experiment with and build upon. By running the `dbt seed` command, we'll load the sample data into our database, creating a foundation for our data transformation and modeling work. The seed data includes a variety of tables, such as `customers`, `orders`, and `products`, which we can use to demonstrate key dbt concepts like data modeling, data transformation, and data quality checks. With the seed data in place, we'll be able to explore the power of dbt and start building our Data Control Plane, integrating with other tools and frameworks to create a robust and scalable data management platform.

While dbt Seed is a convenient way to load sample data into a dbt project, it's not recommended as a mechanism for data ingestion into a production warehouse. Here are a few reasons why:

* **Data Volume**: dbt Seed is designed for loading small to medium-sized datasets, typically for development and testing purposes. It's not optimized for handling large volumes of data, which can lead to performance issues and slow data loading times.

**Task**
```bash
# This task below will install all required libraries and seed the Jaffle Shop data into Databricks
task dbt:seed_databricks

## Similar to above, the same will happen with Snowflake platform with an additional step to create a Snowflake Database automatically.
task dbt:seed_snowflake
```
## Data Governance Layer
In the Data Control Plane project, data governance and data contracts are crucial for ensuring trustworthiness and accountability in data sharing between components. We use Data Contract Manager to create formal agreements that outline the scope of data sharing, responsibilities, and expectations for data quality, security, and usage. For example, a data contract outlining producer's obligations to concise data quality rules can be easily exported into SodaCL Core YAML Contracts and tested against the Data Contract servers with the `datacontract-cli`. By establishing clear data contracts and governing data shared between components, we build a foundation of trust, accountability, and data quality, enabling a robust and scalable data management framework that supports data-driven decision-making and innovation.

```bash
# This task will export Data Contracts from the DBML Schema Contract, and publish into the Data Contract Manager for the Jaffle Shop data which has been ingested into Databricks server.
task dcm:publish_databricks

# Similar to above, this will export Data Contracts if not already done so, and consolidate Snowflake server details with Databricks in the Data Contracts before finally publishing into Data Contract Manager.
task dcm:publish_snowflake
```

## Data Quality

In the Data Control Plane project, data quality is a top priority to ensure that the data shared between components is accurate, complete, and reliable. We use SodaCL Core to define and enforce data quality checks, ensuring that data meets the required standards before it is used for decision-making. By integrating SodaCL Core with dbt and Data Contract Manager, we can automate data quality validation and monitoring, detecting issues and anomalies in real-time. This enables us to identify and address data quality problems early on, preventing downstream errors and ensuring that our data management framework produces high-quality, trustworthy data that supports informed decision-making and innovation.

We are excited to incorporate Great Expectations into our Data Control Plane project to further enhance our data quality capabilities. Great Expectations provides a powerful framework for defining and validating data expectations, which aligns perfectly with our data quality goals. However, to seamlessly integrate Great Expectations into our existing CI/CD pipeline, we need to craft a custom CLI that complements our established patterns. This custom CLI will enable us to leverage Great Expectations' capabilities while maintaining our automated testing and validation workflows. Once developed, the custom CLI will allow us to integrate Great Expectations with our dbt and SodaCL Core workflows, providing a comprehensive data quality solution that ensures our data is accurate, complete, and reliable.

```bash
# This task will export agnostic Data Contract DQ rules into SodaCL-Core syntactical Contracts, and build the configuration to allow us to connect to the Jaffle-Shop data sources created with dbt inside our Databricks Warehouse
task soda:build
task soda:run_databricks

#The soda:build step has likely already collected our snowflake configurations already, so we only need to run the following task to run our SodaCL-Core validators against the data sources in Snowflake
task soda:run_snowflake
```

# Tear Down

In the Data Control Plane project, we follow best practices for tearing down resources to ensure a clean and efficient development environment. When a resource is no longer needed, we make sure to properly delete or deprovision it to avoid unnecessary costs and clutter. This includes deleting databases, dropping tables, and removing dependencies. We also use tools like dbt to automate the process of tearing down resources, making it easy to clean up after ourselves. Additionally, we use CI/CD pipelines to automate the process of tearing down resources in a controlled and reproducible manner. By following these best practices, we ensure that our development environment remains organized and efficient, and that we avoid common pitfalls like resource leaks and orphaned dependencies.

If we're not planning on continuing to the next steps in: [dbt Tranformation Example](https://github.com/effem-jg-org/dbt-transform-example), then it's best practice to tear down the POC assets/ resources

```bash
# Clean Soda results and configurations
task soda:clean

# Clean DCM Source Systems/ Contracts/ Products
task dcm:clean

# Clean dbt Logs/ Target details, and release platform resources like Snowflake Schema/Database and Databricks Schema
task dbt:clean
```