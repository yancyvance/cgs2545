# Grocery Database: MySQL Demonstration

This repository contains SQL scripts designed to support hands-on demonstrations and exercises for an introductory database course using **MySQL** and **MySQL Workbench**.

The scripts use a synthetic grocery database to demonstrate relationships between tables, Cartesian products, `CROSS JOIN`, `INNER JOIN`, `NATURAL JOIN`, multi-table queries, aggregate functions, grouping, and filtering aggregated results.

## Files

### 1. `01 Create and Populate Grocery Database.sql`

This script creates and populates the `grocery` database with synthetic data for classroom demonstrations. It provides related tables representing products, product categories, employee departments, customers, employees, orders, and order details.

### 2. `02 Join Operations.sql`

**Work in progress:** This script is still being developed and may be expanded or revised as additional topics are introduced. The current version progressively introduces queries involving multiple tables, beginning with Cartesian products and continuing through joins and aggregate calculations. The examples use `Category`, `Department`, `Product`, and `OrderDetail`. Here, `Department` represents employee departments and is used alongside `Category` to illustrate a Cartesian product, not a product-to-department relationship.

Topics currently covered include:

- **Examining tables:** Using `USE`, `SHOW TABLES`, and `SELECT *` to inspect the database.
- **Cartesian products:** Comparing comma-separated tables with explicit `CROSS JOIN` syntax.
- **Ambiguous column references:** Demonstrating why shared column names must be qualified with table names or aliases.
- **Filtering matching rows:** Using `WHERE` to retain related records from a Cartesian product.
- **Table aliases:** Writing concise, qualified column references.
- **INNER JOIN:** Using `ON` to specify matching conditions between related tables.
- **NATURAL JOIN:** Exploring automatic matching based on identically named columns and its limitations.
- **Filtering joined records:** Finding products belonging to a particular category.
- **Aggregate functions:** Using `COUNT()`, `AVG()`, and `SUM()` to summarize joined data.
- **Grouping:** Using `GROUP BY` to calculate statistics for each category or order.
- **Calculated columns:** Multiplying order quantities by unit prices to calculate line-item subtotals.
- **Filtering groups:** Using `HAVING` to retrieve orders that meet a minimum grand total.

#### Key Takeaways

- A Cartesian product pairs every row in one table with every row in another; a join condition can restrict the result to matching pairs.
- Unqualified column names are ambiguous when multiple referenced tables contain the same column name.
- Table aliases make multi-table queries easier to read and maintain.
- `INNER JOIN` returns matching rows based on the condition specified in `ON`.
- `NATURAL JOIN` infers matching columns from shared names, which can make queries sensitive to schema changes.
- `WHERE` filters individual rows, while `HAVING` filters groups after aggregation.
- `COUNT(*)` counts joined rows; `SUM(Qty)` counts units purchased, which is a different measure.
- `GROUP BY` produces one aggregate result per group, such as one summary per category or order.
- A line-item subtotal can be calculated as `Qty * UnitPrice`; an order total can be calculated using `SUM(Qty * UnitPrice)`.

**Important:** One statement intentionally produces an ambiguous-column error by comparing `CategoryID = CategoryID` after joining tables that both contain a `CategoryID` column. The corrected statement explicitly qualifies each column. Execute the demonstration statements individually and examine the error before proceeding.

## Getting Started

1. Open MySQL Workbench and connect to your MySQL server.
2. Open and execute `01 Create and Populate Grocery Database.sql` to create and populate the database.
3. Open `02 Join Operations.sql`.
4. Execute `USE grocery;` and `SHOW TABLES;` to select and inspect the database.
5. Run the currently available numbered tasks in sequence, comparing the outputs of `CROSS JOIN`, filtered Cartesian products, and `INNER JOIN`.
6. Examine the intentionally incorrect query and then execute its corrected version.
7. Continue through the product statistics and order-total calculations, observing how `GROUP BY` and `HAVING` change the results.

**Note:** The demonstration assumes that the `grocery` database and its sample records have already been created. Execute the setup script before running the queries.

## Database Overview

| Table | Description |
|---|---|
| `Category` | Stores product categories used to classify products. |
| `Department` | Stores organizational departments to which grocery store employees belong. |
| `Product` | Stores product information, including category associations and unit prices. |
| `OrderDetail` | Stores individual order line items, including purchased products and quantities. |
| `OnlineOrder` | Stores order-level information. |
| `Customer` | Stores customer information associated with orders. |
| `Employee` | Stores employee information, including reporting relationships. |

### Entity-Relationship Diagram

The following diagram illustrates the structure of the university database, including its tables, primary keys, foreign keys, and relationships.

![University Database ER Diagram](images/grocery-erd.png)

## Requirements

- MySQL 8.0 or later
- MySQL Workbench (recommended)

## Disclaimer

All data provided in this repository is **synthetic and intended for educational purposes only**. The records do not represent actual customers, employees, transactions, or businesses. Any resemblance to real individuals or entities is purely coincidental.
