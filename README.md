Markdown
# Software Re-Engineering Project: Database Refactoring & ETL Migration

**Institution:** National University of Computer and Emerging Sciences (FAST-NUCES)
**Instructor:** Ma’am Muzzamal Asghar
**Team Members:** * Muhammad Hasnain (22F-3718) | Section: SE-8A
* Asfand Ahmed (22F-3727) | Section: SE-8A

## Project Overview
This repository contains the deliverables for **Parts E, F, and G** of the Software Re-Engineering project. It focuses on the architectural analysis and modernization of the legacy `HealthBridge Hospital Management System` database. The project involves identifying critical data smells in a 15-year-old schema, normalizing the structure up to the 3rd Normal Form (3NF) using the Prisma ORM, applying specific schema refactoring patterns, and building a secure, automated Python ETL (Extract, Transform, Load) pipeline to migrate legacy CSV records without data loss.

## Repository Contents
* `prisma/schema.prisma`: The refactored, fully normalized database schema built using Prisma ORM.
* `prisma/migrations/`: Contains the generated SQL migration scripts mapping the Prisma schema to MySQL.
* `migration_etl.py`: The Python ETL pipeline script responsible for transforming and validating legacy data before insertion.
* `legacy_appointments.csv`: The legacy source data (10 sample rows) used to simulate the migration cutover.
* `Project_Report.pdf`: Comprehensive documentation detailing data smell detection, structural refactoring decisions, and post-migration validation checks.

## Setup & Execution Instructions

### 1. Database Initialization (Docker)
Ensure Docker Desktop is running, then spin up a local MySQL 8.0 container:
```bash
docker run --name healthbridge-db -e MYSQL_ROOT_PASSWORD=admin123 -e MYSQL_DATABASE=healthbridge -p 3306:3306 -d mysql:8.0
### 2. Load the Refactored Schema (Prisma)
Navigate to the project root directory and apply the new 3NF schema to the MySQL database:

Bash
npx prisma migrate dev --name init_refactored_schema
Note: You can verify the tables were created successfully by opening Prisma Studio:

Bash
npx prisma studio
### 3. Execute the ETL Migration Pipeline
Before running the Python script, ensure you have the MySQL connector installed:

Bash
pip install mysql-connector-python
Run the migration script to parse the legacy_appointments.csv, validate status codes, normalize data fields, and load them into the new database:

Bash
python migration_etl.py
Expected Output: Done. Skipped 1 rows with invalid status: ['1007']

### 4. Post-Migration Validation
Log into the MySQL container to execute the G4 validation queries:

Bash
mysql -h 127.0.0.1 -P 3306 -u root -p
# Enter password: admin123
Once logged into the MySQL monitor, run the following commands to verify the migration:

SQL
USE healthbridge;

-- V1: Check total migrated rows
SELECT COUNT(*) AS migrated_rows FROM Appointment;

-- V2: Check for any NULL dates
SELECT COUNT(*) AS null_dates FROM Appointment WHERE date IS NULL;

-- V3: Verify valid status codes
SELECT DISTINCT status FROM Appointment;

-- V4: Check for orphan appointments
SELECT COUNT(*) AS orphans FROM Appointment a
LEFT JOIN Patient p ON a.patientId = p.id
WHERE p.id IS NULL;