# 🏡 Real Estate Development and Management System (REDMS)

This repository tracks the development of the REDMS, with Phase 5 representing the finalization of the data access layer for integration with the backend application.

---

## 🔒 Phase 5: Data Access, Integrity Checks, and Application CRUD

Phase 5 focuses on developing robust and verified SQL queries that the application's backend will use for all **Create, Read, Update, and Delete (CRUD)** operations. This phase ensures data integrity is maintained at the operational level and prepares the database for final deployment.

### Objectives of Phase 5
1.  **CRUD Implementation:** Develop a complete set of `SELECT`, `INSERT`, `UPDATE`, and `DELETE` queries for key operational tables (e.g., `Vendors`, `Materials`, `PurchaseOrders`).
2.  **Data Validation & Anomalies:** Implement queries to detect and report on potential data issues (e.g., duplicate IDs, low stock, missing updates).
3.  **Application Transaction Examples:** Provide clear SQL examples of multi-step business transactions (e.g., simultaneous material order and payment update).
4.  **Final Cleanup:** Perform final data checks and query optimizations before API integration.

---

## 📁 Phase 5 SQL File Structure

The file **`PHASE 5.SQL`** is dedicated to providing the definitive SQL logic for core business operations, primarily focused on the **Procurement** and **Inventory** domains.

### Highlights of Implemented Features

| Feature Category | Description | Example Logic in `PHASE 5.sql` |
| :--- | :--- | :--- |
| **Vendor Management** | Comprehensive CRUD and reporting on **T10: Vendors**. | Select vendors by location, service type, email pattern, and **detect duplicate GSTNumbers** (data anomaly detection). |
| **Material Inventory** | Operational queries for **T11: Materials** inventory control. | Identify materials with **low stock** (`StockQuantity < 100`) or **zero stock**. Find the most expensive materials. |
| **Procurement Workflow** | CRUD for **T12: PurchaseOrders** and **T24: Invoices**. | List pending purchase orders, calculate total cost for open orders, and update order status. |
| **Data Insertion (DML)** | Definitive examples of adding new records for testing application inserts. | **`INSERT`** statements for adding new `Vendors`, `Materials`, and `PurchaseOrders`. |
| **Operational Transactions** | Demonstration of atomic transactions for business logic requiring multiple steps. | **`START TRANSACTION`** block that simultaneously **inserts a Payment** and **updates a PurchaseOrder status** to 'Paid', ensuring data consistency. |
| **Data Update & Deletion** | Standardized `UPDATE` and `DELETE` statements used by the application for record management. | Update vendor ratings, modify material prices, and delete specific records. |

---

## 🏁 Project Status: Data Access Layer Complete

With the comprehensive development completed across all five phases, the **REDMS Database Layer** is fully structured, optimized, secured, and equipped with all necessary data access logic.

### Next Steps (API Integration)

1.  **API Development Focus:** The backend API's data access functions will now directly call the finalized queries, procedures, and views developed in Phases 2-5.
2.  **Testing Environment:** Use the detailed CRUD queries in `PHASE 5.SQL` as the **unit tests** for the API's database interaction layer (ensuring the application saves, retrieves, and updates data correctly).
3.  **Final Deployment:** Proceed with integrating the API with the frontend for a full-stack application launch.
