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