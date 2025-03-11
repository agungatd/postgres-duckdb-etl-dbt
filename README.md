# dbt-ecommerce-data-warehouse

This project uses dbt (data build tool) to build a data warehouse for e-commerce data, transforming data from a normalized PostgreSQL database into a star schema in DuckDB.

## Overview

This project demonstrates a complete ETL (Extract, Transform, Load) process:

*   **Extract:** Data is read from a PostgreSQL database containing normalized e-commerce data (orders, customers, products, etc.).
*   **Transform:**  dbt models transform the raw data into a star schema, suitable for analytical queries.  This includes:
    *   **Staging Models:**  Clean and prepare data from the source tables.
    *   **Mart Models:**  Create dimension and fact tables.
*   **Load:** The transformed data is loaded into a DuckDB database.

## Prerequisites

*   **Python (3.7+):** Ensure you have a compatible Python version installed.
*   **dbt CLI:** Install with `pip install dbt-postgres dbt-duckdb`.
*   **PostgreSQL:** A running PostgreSQL instance with your e-commerce data.  You'll need connection credentials (host, port, user, password, database name).
*   **DuckDB:** Included with `dbt-duckdb`. For a persistent database, ensure `duckdb` is installed (`pip install duckdb`).
*   **Git (Optional):**  Recommended for version control.

## Project Setup

1.  **Clone the Repository:**
    ```bash
    git clone [your_repository_url]
    cd dbt-ecommerce-data-warehouse
    ```

2.  **Configure `profiles.yml`:**

    *   Create or edit the `~/.dbt/profiles.yml` file to include connection details for *both* PostgreSQL (your source) and DuckDB (your target).  See the example below.  **Important:** The top-level profile name (`ecommerce_dw` in the example) *must* match the `profile` value in your `dbt_project.yml`.

    ```yaml
    # ~/.dbt/profiles.yml
    ecommerce_dw:
      outputs:
        dev_postgres: # Profile for PostgreSQL source
          type: postgres
          host: your_postgres_host  # Replace with your PostgreSQL host
          port: 5432
          user: your_postgres_user  # Replace with your PostgreSQL user
          password: your_postgres_password  # Replace with your password
          dbname: your_postgres_database  # Replace with your PostgreSQL database name
          schema: public  # Or the schema where your e-commerce data resides

        dev_duckdb: # Profile for DuckDB destination
          type: duckdb
          path: ':memory:'  # In-memory DuckDB for development.
          # path: 'ecommerce_dw.duckdb'  # Persistent DuckDB database file.
          schema: main

      target: dev_duckdb  # Default target for development
    ```

    *   Replace the placeholder values with your actual PostgreSQL connection information.  Use `':memory:'` for a temporary in-memory DuckDB database, or a file path (e.g., `'ecommerce_dw.duckdb'`) for a persistent database.

3. **Configure `dbt_project.yml`:**

   * Review and, if necessary, modify the `dbt_project.yml` file.  Ensure that the `profile` setting matches the top-level name in your `profiles.yml`.  The `sources` section defines how dbt connects to your PostgreSQL source database and the tables it will use.

4.  **Install Dependencies**
    ```bash
    dbt deps
    ```

## Running the Project

1.  **Test the Connections:**
    ```bash
    dbt debug
    ```
    This command verifies that dbt can connect to both your PostgreSQL and DuckDB databases.

2.  **Run the Models:**
    ```bash
    dbt run
    ```
    This command executes all the SQL models in your project, creating the staging and mart tables in your DuckDB database.  You can also run specific models:
    ```bash
    dbt run -s staging  # Run only the staging models
    dbt run -m fact_orders  # Run only the fact_orders model
    ```

3.  **Run Tests:**
    ```bash
    dbt test
    ```
    This runs all data tests defined in your `schema.yml` files.  These tests help ensure data quality and consistency.  You can run tests for specific models:
    ```bash
    dbt test -s stg_orders  # Run tests for the stg_orders model
    ```

4.  **Generate Documentation:**
    ```bash
    dbt docs generate
    dbt docs serve
    ```
    This generates and serves a local website with documentation for your project, including model descriptions, column definitions, lineage graphs, and test results.

## Project Structure Explained

*   **`dbt_project.yml`:**  The main configuration file for your dbt project.
*   **`models/`:** Contains all your SQL models.
    *   **`staging/`:** Models that directly read from the PostgreSQL source, performing basic cleaning and renaming.
    *   **`marts/`:** Models that build the final star schema (dimension and fact tables).
*   **`tests/`:** Contains custom, reusable data tests.
*   **`macros/`:** Contains reusable SQL macros (e.g., for generating a date dimension).
*   **`seeds/`:** (Optional)  Contains static data that can be loaded into your data warehouse (e.g., lookup tables).
*   **`analysis/`:** (Optional)  A place for ad-hoc SQL queries and analysis that are not part of the core ETL process.
*   **`target/`:** A directory where dbt compiles your SQL models.  You generally don't need to interact with this directory directly.
* **`dbt_packages/`**: Contains the installed dbt dependencies.

## Data Model

The project transforms data into a star schema with the following tables:

*   **`dim_customers`:** Customer dimension.
*   **`dim_products`:** Product dimension.
*   **`dim_date`:** Date dimension.
*   **`fact_orders`:** Orders fact table, containing transactional data.

## Key Concepts

*   **Star Schema:** A data warehousing design that organizes data into fact tables (containing measurements) and dimension tables (containing descriptive attributes).
*   **dbt Models:** SQL files that define transformations on your data.
*   **Materializations:** How dbt creates tables or views in your database (`view`, `table`, `incremental`, `ephemeral`).
*   **Sources:** How dbt connects to your source database(s).
*   **Tests:**  Assertions about your data to ensure quality and consistency.
*   **Macros:** Reusable SQL code snippets.

## Next Steps

*   **Add More Dimensions:** Extend the star schema with additional dimensions (e.g., location, promotions).
*   **Incremental Models:** Configure models to load data incrementally, improving performance for large datasets.  Use `{{ config(materialized='incremental') }}` and the `is_incremental()` macro.
*   **Snapshots:** Implement dbt snapshots to track changes in slowly changing dimensions.
*   **Deployment:** Deploy your dbt project to a production environment (e.g., using dbt Cloud or a scheduler like Airflow).
