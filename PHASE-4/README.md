# 🏡 Real Estate Development and Management System (REDMS)

This repository tracks the development of a comprehensive Real Estate Development and Management System (REDMS), now focusing on optimizing the database for application deployment.

---

## 🔒 Phase 4: Database Optimization, Application Logic, and Security

Phase 4 concludes the database development process by focusing on creating essential reporting structures, automating data iteration, and implementing database security. The goal is to create a secure, high-performance data layer that can be easily consumed by a backend API.

### Objectives of Phase 4
1.  **Reporting Simplification:** Create permanent, simplified **Views** for the application's reporting dashboards.
2.  **Logic Automation:** Implement database-level iteration using **Cursors** and complex state management using **Transactions (TCL)**.
3.  **Performance Tuning:** Utilize **Window Functions** for highly efficient, ranked data analysis.
4.  **Security & Access:** Define user permissions using **Data Control Language (DCL)** statements.

---

## 📁 Phase 4 SQL File Structure

The file **`PHASE 4.sql`** contains the final set of SQL objects and statements necessary to productionize the database.

### Highlights of Implemented Features

| Feature Category | Description | Example Logic in `PHASE 4.sql` |
| :--- | :--- | :--- |
| **Views (Reporting)** | Creating virtual tables to simplify complex, frequently run queries for reporting tools and APIs. | **`OngoingProjects`**: Shows only active project data. **`AvgBudgetByType`**: Provides immediate access to aggregate financial summaries. |
| **Stored Procedures** | Encapsulating multi-step business processes for application calls. | **`ShowProjectNames()`**: Demonstrates the use of a **Cursor** to iterate through a result set for processes like bulk logging or data migration. |
| **Data Control Language (DCL)** | Managing user access and permissions to enforce security policies. | **`GRANT SELECT`** to a `viewer_user` to restrict read-only access. **`REVOKE DELETE`** to prevent accidental data loss. |
| **Transaction Control (TCL)** | Ensuring data integrity by grouping multiple SQL statements into a single, atomic unit of work. | **`START TRANSACTION; ... COMMIT;`** logic to ensure related **UPDATE** statements (e.g., resolving status and updating resolution date) succeed or fail together. |
| **Advanced Window Functions** | Utilizing advanced SQL functions for fast ranking and comparison within partitions. | **`RANK()`** projects by budget and **`DENSE_RANK()`** by start date within project types. |
| **CORS and Logic** | Procedures to update or analyze data based on specific conditions passed by the application (e.g., **`IncreaseBudgetByLocation`**). | Updating budgets only for projects in a specific city, callable directly from the backend. |

---

## 🏁 Project Status: Database Complete

With the successful execution of Phase 4, the **REDMS Database Layer** is considered complete and production-ready.

### Next Steps (Application Phase)

1.  **Backend API Development:** Begin building the RESTful API endpoints (using Python, Node.js, etc.) to expose the data and logic implemented in our Stored Procedures and Views.
2.  **ORM Integration:** Configure the Object-Relational Mapper (ORM) to primarily interact with the simplified **Views** and call the complex **Stored Procedures** for core application functions, maximizing efficiency.
3.  **Frontend/UI Development:** Connect the user interface to the newly created API endpoints to create a seamless user experience for managing projects, sales, and operations.

