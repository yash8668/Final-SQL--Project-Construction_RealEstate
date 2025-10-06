# 🏢 Construction & Real Estate Database Analytics

## 📝 Project Description

This repository contains a comprehensive set of **25 advanced SQL queries** designed for a `Construction_RealEstate` relational database schema. The queries utilize advanced SQL features, including **Window Functions (Rolling Averages and Ranking)**, **Common Table Expressions (CTEs)**, **Recursive CTEs** (for hierarchical data), and complex `JOIN` operations.

This collection is intended to provide powerful, actionable business intelligence and operational reporting from the core database, covering sales, construction progress, maintenance, human resources, and financial performance.

## ✨ Features

The `PHASE 5.SQL` file provides solutions for 25 distinct business intelligence questions, including:

* **Financial & Sales Analysis:**
    * Calculate the **90-day rolling average** of total daily sales price, partitioned by project type.
    * Identify projects where the **Total Sales Revenue** of all sold properties **exceeds the Project's initial Budget**.
    * Calculate the **Budget Variance Percentage** (Actual Cost vs. Budget) for each construction phase and rank them from worst to best.
    * Determine the **year-over-year growth rate** in Total Sales Price for "Residential" properties.

* **Operational & Resource Management:**
    * Find the **top 3 best-rated Contractors** by average rating who have been assigned a Maintenance Request in the last 6 months.
    * Retrieve all Materials that have their **StockQuantity less than 10%** of the total Quantity ordered across all Purchase Orders.
    * Determine the **average lead conversion rate** (Converted Leads / Total Leads) per month for the last 6 months.

* **Hierarchical & HR Reporting:**
    * List all Employees, their direct Manager's name, and the total count of subordinates (direct and indirect) under them, leveraging a **Recursive CTE**.
    * Use a **Recursive CTE** to find the full management chain (from CEO down to each Employee).

## 🛠️ Prerequisites

To run these queries, you will need:

* A **MySQL** or **MariaDB** installation (or a compatible SQL environment).
* An existing database named `Construction_RealEstate` (as referenced in the first line of the script).
* The database must be populated with the necessary tables (e.g., `Sales`, `Projects`, `Employees`, `Contractors`, etc.) and data to match the query structures.

## 🚀 Usage

Follow these steps to set up the project and run the queries:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/YourUsername/YourRepoName.git](https://github.com/YourUsername/YourRepoName.git)
    cd YourRepoName
    ```

2.  **Run the Script:**
    You can execute the entire script from your SQL client (e.g., MySQL Workbench, DBeaver) or via the command line.

    **Using the MySQL Command Line:**
    ```bash
    mysql -u [your_username] -p Construction_RealEstate < "PHASE 5.SQL"
    ```
    *(Note: Replace `[your_username]` with your actual MySQL username.)*

3.  **Review the Output:**
    The queries are designed to produce reporting-style result sets directly in your SQL client.

## 📄 License

This project is licensed under the **MIT License** - see the `LICENSE.md` file (if you create one) for details.

## ✍️ Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
