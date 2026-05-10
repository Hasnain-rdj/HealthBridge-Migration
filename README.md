# Software Re-Engineering Project  
## Database Refactoring & ETL Migration

**Institution:** National University of Computer and Emerging Sciences (FAST-NUCES)  
**Instructor:** Ma’am Muzzamal Asghar  

### Team Members
- Muhammad Hasnain (22F-3718) — Section SE-8A  
- Asfand Ahmed (22F-3727) — Section SE-8A  

---

# Project Overview

This repository contains the implementation and deliverables for Parts **E, F, and G** of the Software Re-Engineering project. The project focuses on the modernization and architectural restructuring of the legacy **HealthBridge Hospital Management System** database.

The primary objective was to identify critical data smells in a 15-year-old database schema, redesign the structure using normalization principles up to **Third Normal Form (3NF)**, and migrate legacy records into the new architecture through a secure and automated ETL pipeline.

The refactored solution was implemented using the **Prisma ORM** with a **MySQL 8.0** backend, while the migration process was handled using a custom-built Python ETL script.

---

# Project Objectives

- Detect structural issues and database design smells in the legacy schema.
- Refactor and normalize the database up to 3NF.
- Apply schema refactoring and restructuring techniques.
- Build an automated ETL pipeline for legacy data migration.
- Validate migrated records to ensure consistency and integrity.
- Prevent data loss during migration.

---

# Repository Structure

```plaintext
├── prisma/
│   ├── schema.prisma
│   └── migrations/
│
├── migration_etl.py
├── legacy_appointments.csv
├── Project_Report.pdf
└── README.md
```

---

# File Descriptions

### `prisma/schema.prisma`
Contains the fully refactored and normalized Prisma schema representing the redesigned database structure.

### `prisma/migrations/`
Stores the generated SQL migration scripts used to map the Prisma schema to MySQL.

### `migration_etl.py`
Python ETL pipeline responsible for:
- Extracting legacy CSV records
- Transforming and validating data
- Loading records into the new database schema

### `legacy_appointments.csv`
Sample legacy dataset containing appointment records used to simulate migration cutover scenarios.

### `Project_Report.pdf`
Comprehensive project documentation covering:
- Data smell analysis
- Refactoring decisions
- Schema redesign
- ETL implementation
- Migration validation results

---

# Technologies Used

- Prisma ORM
- MySQL 8.0
- Python
- Docker
- SQL
- CSV Data Processing

---

# Setup & Execution Guide

## 1. Initialize MySQL Database Using Docker

Ensure Docker Desktop is running, then execute:

```bash
docker run --name healthbridge-db \
-e MYSQL_ROOT_PASSWORD=admin123 \
-e MYSQL_DATABASE=healthbridge \
-p 3306:3306 \
-d mysql:8.0
```

---

## 2. Apply the Refactored Prisma Schema

Navigate to the project directory and run:

```bash
npx prisma migrate dev --name init_refactored_schema
```

To inspect the generated tables visually:

```bash
npx prisma studio
```

---

## 3. Execute the ETL Migration Pipeline

Install the required MySQL connector:

```bash
pip install mysql-connector-python
```

Run the migration script:

```bash
python migration_etl.py
```

### Expected Output

```plaintext
Done. Skipped 1 rows with invalid status: ['1007']
```

---

# Post-Migration Validation

Connect to the MySQL instance:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p
```

Password:

```plaintext
admin123
```

Once connected:

```sql
USE healthbridge;
```

---

## Validation Queries

### V1 — Verify Total Migrated Rows

```sql
SELECT COUNT(*) AS migrated_rows
FROM Appointment;
```

### V2 — Check for NULL Dates

```sql
SELECT COUNT(*) AS null_dates
FROM Appointment
WHERE date IS NULL;
```

### V3 — Validate Appointment Status Codes

```sql
SELECT DISTINCT status
FROM Appointment;
```

### V4 — Detect Orphan Appointment Records

```sql
SELECT COUNT(*) AS orphans
FROM Appointment a
LEFT JOIN Patient p ON a.patientId = p.id
WHERE p.id IS NULL;
```

---

# Key Features

- Legacy database modernization
- 3NF-compliant schema design
- Automated ETL migration pipeline
- Data validation and integrity checks
- Dockerized database deployment
- Prisma-based migration management

---

# Expected Learning Outcomes

This project demonstrates practical implementation of:

- Database normalization
- Software re-engineering
- Schema refactoring
- Data migration strategies
- ETL workflows
- Database validation techniques
- Legacy system modernization
