# 🏡 Real Estate Development and Management System (REDMS)

This repository tracks the development of a comprehensive Real Estate Development and Management System (REDMS) designed to manage construction projects, procurement, sales, leasing, and maintenance.

---

## ⚙️ Phase 3: Advanced SQL Functions and Data Automation

Phase 3 transitions from simple query development to implementing advanced SQL features that enhance data manipulation, automate complex business logic, and improve database performance. This phase is critical for preparing the database for integration with the application layer.

### Objectives of Phase 3
1.  **Implement Complex Joins:** Master reporting across multiple domain tables (e.g., Sales, Property, Agent, Client).
2.  **Advanced Query Techniques:** Utilize **Subqueries**, **Correlated Subqueries**, and **Window Functions** for sophisticated data analysis (e.g., ranking, partitioning).
3.  **Enhance Automation:** Develop **User-Defined Functions (UDFs)** and **Stored Procedures** to encapsulate business logic and improve application efficiency.
4.  **Data Integrity Enforcement:** Introduce basic **Triggers** to ensure specific business rules are always followed at the database level.

---

## 📁 Phase 3 SQL File Structure

The file **`PHASE 3.sql`** is the focus of this phase and contains a wide variety of advanced SQL code, organized by the feature implemented.

### Highlights of Implemented Features

| Feature Category | Description | Example Queries / Logic in `PHASE 3.sql` |
| :--- | :--- | :--- |
| **Complex Joins** | Combining data from 3+ tables to answer specific business questions. | Listing all **Clients** who bought a **Property** in an **'Ongoing' Project**. |
| **Subqueries** | Using results from one query to filter or calculate values in another. | Finding **Projects** with a **Budget** higher than the overall average project budget. |
| **Correlated Subqueries** | Performing row-by-row filtering based on conditions in the outer query. | Identifying the latest **Payment** for each **SaleID**. |
| **Window Functions** | Performing calculations across a set of table rows related to the current row without grouping. | **RANK()** Feedback by rating within each **Agent's** portfolio. |
| **User-Defined Functions (UDFs)** | Creating reusable functions for simple logic checks. | `IsPositive(rating)`: Determines if a client **Feedback** rating is positive (e.g., rating >= 4). |
| **Stored Procedures** | Encapsulating complex logic or transaction steps into a single callable block. | Procedure to insert a new **Sale** record and update the **PropertyListings** status to 'Sold' simultaneously. |
| **Triggers** | Automating actions based on `INSERT`, `UPDATE`, or `DELETE` events. | **BEFORE INSERT** trigger to automatically capitalize **Project Names**. |

---

## 🛠️ Next Steps

With Phase 3 complete, the database layer is highly optimized and ready for application development:

1.  **API Development (Phase 4):** Building a backend API (e.g., using Python/Django, Node.js/Express, or Java/Spring) that interacts with the Stored Procedures and Views created in this phase.
2.  **Frontend Integration:** Connecting the application frontend (UI/UX) to the API layer to present the data and allow users to execute the underlying complex logic.
3.  **ORMs Configuration:** Utilizing the defined keys, constraints, and advanced functions to configure an Object-Relational Mapper (ORM) for efficient application development.

