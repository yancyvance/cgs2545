# University Database: MySQL Demonstration

This repository contains SQL scripts designed to support hands-on demonstrations and exercises for an introductory database course using **MySQL** and **MySQL Workbench**.

The scripts use a simplified university database to demonstrate database creation, data manipulation, integrity constraints, referential actions, and SQL queries.

## Files

### 1. `01 Create University Database.sql`

This script guides students through creating and modifying a university database.

Topics covered include:

- Creating databases and tables using `CREATE DATABASE` and `CREATE TABLE`.
- Defining primary keys, foreign keys, and unique constraints.
- Inserting, updating, and deleting records.
- Modifying table structures using `ALTER TABLE`.
- Introducing `AUTO_INCREMENT` and composite keys.
- Enforcing data integrity using `CHECK` constraints.
- Exploring referential actions such as `ON UPDATE CASCADE` and `ON DELETE SET NULL`.
- Reconstructing the database model through reverse engineering in MySQL Workbench.

**Important:** Some SQL statements intentionally produce errors to demonstrate how MySQL enforces integrity constraints. These statements are annotated with explanations and should be executed individually as part of the guided demonstration.

### 2. `02 Sample Database Data.sql`

This script populates the university database with additional synthetic records, providing a larger dataset for practicing SQL queries.

The expanded dataset supports exercises involving:

- Retrieving and filtering records using `SELECT` and `WHERE`.
- Sorting results using `ORDER BY`.
- Working with logical and comparison operators.
- Handling missing values using `IS NULL` and `IS NOT NULL`.


## Getting Started

1. Open MySQL Workbench and connect to your MySQL server.
2. Open `01 Create University Database.sql`.
3. Execute the SQL statements incrementally, following the comments and observing the expected errors.
4. Once the demonstration is complete, open `02 Sample Database Data.sql`.
5. Execute the sample data script to populate the database with additional records.
6. Use the resulting database for SQL querying exercises.

**Note:** Execute the scripts in the order indicated by their filenames. The second script assumes that the database and its tables have already been created.

## Database Overview

| Table | Description |
|---|---|
| `Student` | Stores student information, including declared majors and enrollment status. |
| `Course` | Stores course information, including course codes, titles, and credit hours. |
| `Registration` | Stores course registrations, semesters, academic years, and grades. |
| `Department` | Stores academic departments associated with courses. |

## Requirements

- MySQL 8.0 or later
- MySQL Workbench (recommended)

## Disclaimer

All data provided in this repository is **synthetic and intended for educational purposes only**. The records do not represent actual individuals or institutional records. Any resemblance to real individuals or entities is purely coincidental.
