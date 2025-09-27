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





