
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

### 3. `03 Basic Select Statements.sql`

This script introduces fundamental SQL querying techniques using the `Student`, `Course`, and `Registration` tables. The examples progressively demonstrate how to retrieve, filter, and sort data, including how logical expressions affect query results.

Topics covered include:

- **Retrieving and projecting data:** Using `SELECT *` to retrieve all columns and specifying individual columns to display.
- **Filtering records:** Using `WHERE` with comparison operators such as `=`, `!=`, and `<`.
- **Combining conditions:** Using `AND`, `OR`, and parentheses to construct logical expressions.
- **Operator precedence:** Demonstrating how `AND` is evaluated before `OR` and how incorrect grouping can produce unintended results.
- **Matching multiple values:** Using `IN` to simplify conditions involving several possible values.
- **Handling missing values:** Using `IS NULL` and `IS NOT NULL` to identify records with missing or available information.
- **Sorting query results:** Using `ORDER BY` with `ASC` and `DESC`, including sorting by multiple columns.
- **Filtering ranges:** Using `BETWEEN` to retrieve records within an inclusive range.
- **Using arithmetic expressions:** Applying the modulo (`%`) operator within a `WHERE` condition.
- **Combining SQL clauses:** Using projection, filtering, and sorting together in a single query.

#### Key Takeaways

- `SELECT` determines which columns appear in the result, while `WHERE` determines which rows are included.
- `AND` has higher precedence than `OR`. Without appropriate parentheses, a query may return unintended results even when its SQL syntax is valid.
- Parentheses can be used to explicitly group conditions and ensure that the intended logic is applied.
- `IN` provides a concise alternative to multiple equality comparisons joined by `OR`.
- `NULL` represents missing or unknown information and must be checked using `IS NULL` or `IS NOT NULL`, rather than ordinary equality comparisons.
- `ORDER BY` controls how results are arranged. Multiple columns can be used to specify additional sorting criteria when values are tied.
- `BETWEEN` includes both endpoints of the specified range.
- Arithmetic expressions can be used in filtering conditions, such as identifying registrations from even-numbered years.
- SQL clauses can be combined to answer more specific questions without modifying the underlying database.

**Important:** The script includes an intentionally incorrect logical condition involving `AND` and `OR`. Although the query executes successfully, it does not produce the intended results because of operator precedence. A corrected version is provided immediately afterward to demonstrate the importance of grouping conditions using parentheses.

## Getting Started

1. Open MySQL Workbench and connect to your MySQL server.
2. Open `01 Create University Database.sql`.
3. Execute the SQL statements incrementally, following the comments and observing the expected errors.
4. Once the demonstration is complete, open `02 Sample Database Data.sql`.
5. Execute the sample data script to populate the database with additional records.
6. Open `03 Basic Select Statements.sql`.
7. Execute the queries individually, observe the results, and review how each query demonstrates a particular SQL concept.

**Note:** Execute the scripts in the order indicated by their filenames. The second and third scripts assume that the university database and its tables have already been created.

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
