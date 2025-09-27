# 🏡 Real Estate Development and Management System (REDMS)

This repository tracks the development of a comprehensive Real Estate Development and Management System (REDMS) designed to manage construction projects, procurement, sales, leasing, and maintenance.

---

## 🚀 Phase 2: Core Operational and Analytical Queries

Phase 2 builds upon the **Phase 1 Database Architecture** by developing the core SQL queries necessary for daily operational reporting, data analysis, and business intelligence (BI). These queries are essential for extracting meaningful insights from the 25-table relational schema.

### Objectives of Phase 2
1.  **Develop Operational Queries (CRUD):** Create essential `SELECT`, `INSERT`, `UPDATE`, and `DELETE` statements for daily data manipulation across key tables.
2.  **Generate Analytical Queries:** Implement queries utilizing `JOINs`, `GROUP BY`, and aggregation functions to support business reporting (e.g., project profitability, sales performance, inventory status).
3.  **Establish Data Dictionary:** Document query usage and expected output for future application development.

---

## 📁 Phase 2 SQL File Structure

The file **`PHASE2.SQL`** contains an extensive collection of queries, organized by the primary table they target, ensuring modular and clear development.

### Highlights of Implemented Queries

The **`PHASE2.SQL`** script includes dedicated sections covering critical business areas:

| Table / Area | Query Focus | Example Capabilities |
| :--- | :--- | :--- |
| **Projects (T1)** | Project Management & Finance | Calculate total budget by status, find projects in a specific location, and list distinct project types. |
| **Sites (T2)** | Site & Location Intelligence | Count sites per city/state, find available sites by land type, and list sites requiring inspection. |
| **Sales (T7) & Leads (T8)** | Sales Performance & CRM | Determine total sales revenue, calculate agent commissions, track lead conversion rates, and identify high-priority leads. |
| **Materials (T11) & Orders (T12)** | Inventory & Procurement | Check materials with low stock, calculate the total cost of pending **PurchaseOrders**, and find the average price per unit. |
| **Employees (T9) & Agents (T5)** | HR & Staffing | List employees by department/role, find the highest-rated agents, and calculate average employee salaries. |
| **Feedback (T25)** | Client Satisfaction | Calculate average customer rating, count feedback by resolution status, and find customers who submitted multiple feedback entries. |
| **Complex Joins** | Cross-Domain Reporting | **Identify Properties** that are completed but **not yet sold**; find the total **ActualCost** for a specific **ConstructionPhase**. |

---

## 🛠️ Execution and Usage

The `PHASE2.SQL` file is designed to be executed directly against the database created in **Phase 1**.

1.  **Ensure Schema is Ready:** Verify the `Construction_RealEstate` database is set up and populated with the Phase 1 schema and sample data.
2.  **Execute Queries:** Run the `PHASE2.SQL` file through your preferred SQL client (e.g., MySQL Workbench, DBeaver). The queries are structured for easy testing and review.
3.  **Next Steps:** These queries will serve as the backend logic for the reporting dashboards and API endpoints developed in Phase 3.

