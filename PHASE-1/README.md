# 🏡 Real Estate Development and Management System (REDMS)

This repository contains the foundational structure and initial data for a comprehensive Real Estate Development and Management System (REDMS) designed to track the entire lifecycle of construction projects, from initiation and procurement to sales, leasing, and post-sale maintenance.

---

## 🎯 Phase 1: Database Architecture and Schema Implementation

Phase 1 focuses exclusively on establishing the robust **relational database schema** and populating it with initial sample data. This foundation supports all subsequent application development (API, frontend, reporting).

### Objectives of Phase 1
1.  **Schema Definition:** Create 25 normalized tables covering all core business domains.
2.  **Data Integrity:** Define primary and foreign keys to establish relationships and ensure data consistency.
3.  **Initial Data Loading:** Populate all tables with sample data for development and testing purposes.

---

## ⚙️ Core Data Schema Overview (25 Tables)

The REDMS database is organized into the following logical domains:

| Domain | Tables | Description |
| :--- | :--- | :--- |
| **Project Management** | `Projects`, `Sites`, `ConstructionPhases`, `Tasks` | Tracks project status, site details, and construction milestones. |
| **Procurement & Resources** | `Vendors`, `Materials`, `PurchaseOrders`, `Invoices`, `Equipment` | Manages supply chain, inventory, and equipment allocation. |
| **Sales & CRM** | `Clients`, `Agents`, `Leads`, `Sales`, `Feedback` | Handles customer information, lead tracking, sales transactions, and agent performance. |
| **Property & Post-Sale** | `PropertyListings`, `Leases`, `MaintenanceRequests`, `LegalDocuments` | Manages available properties, rentals, documents, and client service requests. |
| **Compliance & Oversight** | `Inspections`, `Permits`, `SiteVisits`, `Budgets` | Tracks regulatory compliance, quality checks, and financial allocations. |
| **Human Resources** | `Employees`, `Contractors` | Stores internal staff, roles, and external specialist details. |
| **Financial** | `Payments` | Tracks financial transactions related to sales. |

---

## ✨ Key Features Implemented by the Schema

The current database structure enables the following core system capabilities:

### 1. Project & Construction Management
* **Project Lifecycle Tracking:** Manage projects from start to finish, broken down into detailed construction phases and tasks.
* **Budget Control:** Allocate and track **Budgets** against specific projects and phases.
* **Site & Quality Oversight:** Record necessary **Permits** and schedule/log **Inspections** and **SiteVisits**.

### 2. Supply Chain & Financials
* **Procurement Workflow:** Formalize **PurchaseOrders** for **Materials** from approved **Vendors**.
* **Inventory & Asset Tracking:** Manage **Material** inventory levels and track **Equipment** assignment to sites.
* **Invoice Processing:** Link **Invoices** to purchase orders for financial reconciliation.

### 3. Sales & Customer Relationship Management (CRM)
* **Comprehensive Client Database:** Centralized management of **Clients**, **Agents**, and **Contractors**.
* **Lead Management:** Track **Leads** by source, priority, assigned agent, and follow-up status.
* **Transaction Record:** Detailed recording of **Sales** and subsequent **Payments**.

### 4. Property and Asset Administration
* **Property Listing Catalog:** Detailed database of all **PropertyListings** with specifications (AreaSqFt, Floor, Facing, etc.).
* **Legal Compliance:** Store and manage associated **LegalDocuments** and **Leases**.
* **Post-Sale Service:** Handle and track **MaintenanceRequests** and capture client **Feedback**.

---

## 🚀 Getting Started

To set up the Phase 1 database on your local machine, you need a MySQL or similar SQL environment (e.g., PostgreSQL, SQL Server may require minor syntax adjustments).

### Prerequisites
* A running instance of a relational database server (e.g., MySQL, MariaDB).
* A database client tool (e.g., MySQL Workbench, DBeaver, or command line).

### Installation Steps

1.  **Create Database:** Execute the following command in your SQL client:
    ```sql
    CREATE DATABASE Construction_RealEstate;
    USE Construction_RealEstate;
    ```
2.  **Run Schema Script:** Open the included file `PHASE 1.sql`.
3.  **Execute:** Run the entire content of `PHASE 1.sql`. This script will:
    * Create all 25 tables.
    * Define all primary and foreign key constraints.
    * Insert sample data into every table.

You should now have a fully populated database named `Construction_RealEstate` ready for development.

Screenshots :

<img width="1228" height="555" alt="image" src="https://github.com/user-attachments/assets/4cd53417-0d89-46c2-a6b7-9a181d4cf547" />

<img width="1127" height="501" alt="image" src="https://github.com/user-attachments/assets/c5924359-6103-4ce4-b9ee-67c8793d230c" />

<img width="1230" height="551" alt="image" src="https://github.com/user-attachments/assets/ac401de4-3289-4a41-a918-604624056306" />

<img width="1145" height="550" alt="image" src="https://github.com/user-attachments/assets/3c191f55-c390-4e99-baeb-bb136d737e9a" />

<img width="1172" height="541" alt="image" src="https://github.com/user-attachments/assets/8775ed0e-69af-4e77-b623-913c96eecf4c" />

<img width="1085" height="531" alt="image" src="https://github.com/user-attachments/assets/d667e276-1fe6-4a02-aed8-5428303a157f" />

<img width="1052" height="561" alt="image" src="https://github.com/user-attachments/assets/c7d9a16b-3595-4952-89c3-77caebce8ade" />

<img width="1100" height="532" alt="image" src="https://github.com/user-attachments/assets/715526b5-29f1-424a-80a6-235e0faaace1" />

<img width="1058" height="492" alt="image" src="https://github.com/user-attachments/assets/c83dcc50-d632-4867-baf2-9ef8896fb16d" />

<img width="1028" height="517" alt="image" src="https://github.com/user-attachments/assets/e838c3cd-7637-43ec-b589-47bda45194d2" />

<img width="1056" height="513" alt="image" src="https://github.com/user-attachments/assets/040c223c-1d82-4e9f-b257-1d29ad0bf8b5" />

<img width="928" height="517" alt="image" src="https://github.com/user-attachments/assets/dc4e7603-b91f-498f-9323-06f74d21bc50" />

<img width="1177" height="586" alt="image" src="https://github.com/user-attachments/assets/c23c74e5-6214-42c0-8983-3a7f3e7f4016" />

<img width="1006" height="605" alt="image" src="https://github.com/user-attachments/assets/b87db62c-7b1a-4941-8152-758789989478" />

<img width="1135" height="560" alt="image" src="https://github.com/user-attachments/assets/f5bc27ac-d00f-4c59-b418-9e517f8b15bb" />

<img width="1082" height="532" alt="image" src="https://github.com/user-attachments/assets/47a17b57-9fb7-4d25-a505-8c8b3d62e3f0" />

<img width="1150" height="532" alt="image" src="https://github.com/user-attachments/assets/5bcee329-1310-4790-afd0-00a71de18931" />

<img width="1086" height="536" alt="image" src="https://github.com/user-attachments/assets/32d978c3-0d80-498b-b8d0-494dd8234f9f" />

<img width="1082" height="520" alt="image" src="https://github.com/user-attachments/assets/4d6e8372-2d7b-4219-a591-841e046bb3dc" />

<img width="1081" height="521" alt="image" src="https://github.com/user-attachments/assets/5af94e65-5a07-407c-b25f-5d92be3454d6" />

<img width="1150" height="545" alt="image" src="https://github.com/user-attachments/assets/d5708d2b-e85e-41b5-bfe9-1097d59c1ba6" />

<img width="1200" height="555" alt="image" src="https://github.com/user-attachments/assets/f6dcf4a7-9e3e-4100-a562-95d1188d98b6" />

<img width="982" height="523" alt="image" src="https://github.com/user-attachments/assets/798da80f-b2cf-46c6-a169-52a48d0652cb" />

<img width="1007" height="527" alt="image" src="https://github.com/user-attachments/assets/b324c7e3-308c-4d29-b2de-0bfd3ed9a383" />

<img width="1076" height="530" alt="image" src="https://github.com/user-attachments/assets/1ca2a586-0dcf-4604-9e62-155e305c7b55" />




