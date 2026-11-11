
# Grocery Database: MySQL Demonstration

This repository contains SQL scripts designed to support hands-on demonstrations and exercises for an introductory database course using **MySQL** and **MySQL Workbench**.

The scripts use a synthetic grocery database to demonstrate relationships between tables, Cartesian products, `CROSS JOIN`, `INNER JOIN`, `NATURAL JOIN`, `LEFT JOIN`, self-joins, multi-table queries, aggregate functions, grouping, filtering aggregated results, and views.

## Files

### 1. `01 Create and Populate Grocery Database.sql`

This script creates and populates the `grocery` database with synthetic data for classroom demonstrations. It provides related tables representing products, product categories, employee departments, customers, employees, orders, and order details.

### 2. `02 Join Operations.sql`

**Work in progress:** This script is still being developed and may be expanded or revised as additional topics are introduced. The current version contains 49 numbered tasks that progressively introduce queries involving multiple tables, beginning with Cartesian products and continuing through joins, aggregate calculations, and views.

The examples use `Category`, `Department`, `Product`, `OrderDetail`, `OnlineOrder`, `Customer`, and `Employee`. Here, `Department` represents employee departments and is used alongside `Category` to illustrate a Cartesian product, not a product-to-department relationship.

Topics currently covered include:

- **Examining tables:** Using `USE`, `SHOW TABLES`, and `SELECT *` to inspect the database.
- **Cartesian products:** Comparing comma-separated tables with explicit `CROSS JOIN` syntax.
- **Ambiguous column references:** Demonstrating why shared column names must be qualified with table names or aliases.
- **Filtering matching rows:** Using `WHERE` to retain related records from a Cartesian product.
- **Table aliases:** Writing concise, qualified column references.
- **INNER JOIN:** Using `ON` to specify matching conditions between related tables.
- **NATURAL JOIN:** Exploring automatic matching based on identically named columns and its limitations.
- **Filtering joined records:** Finding products belonging to a particular category.
- **Multi-table joins:** Combining three or more related tables to retrieve information across customers, orders, order details, and products.
- **Aggregate functions:** Using `COUNT()`, `AVG()`, and `SUM()` to summarize joined data.
- **Grouping:** Using `GROUP BY` to calculate statistics for each category, order, customer, or department.
- **Calculated columns:** Multiplying order quantities by unit prices to calculate line-item subtotals.
- **Filtering groups:** Using `HAVING` to retrieve orders that meet a minimum grand total.
- **Distinct records:** Using `DISTINCT` and `COUNT(DISTINCT ...)` to eliminate duplicate results and count unique values.
- **Purchase-time pricing:** Adding `PurchaseUnitPrice` to `OrderDetail` and using `UPDATE` with `INNER JOIN` to populate the column.
- **Self-joins:** Joining the `Employee` table to itself to examine reporting relationships, count direct reports, and compare employees with their managers.
- **LEFT JOIN:** Preserving records without matching rows, including departments without employees and customers without orders.
- **Finding unmatched records:** Using `LEFT JOIN` with `IS NULL` to demonstrate the anti-join pattern.
- **Counting unmatched records:** Comparing `COUNT(*)` with `COUNT(column)` when using `LEFT JOIN`.
- **Handling NULL values:** Using `COALESCE()` to display zero spending for customers without purchases.
- **Views:** Creating and querying `ListOfCustomerSpending` to reuse a multi-table aggregate query.
- **Sorting and limiting results:** Using `ORDER BY` and `LIMIT` to identify the highest-spending customer.

#### Key Takeaways

- A Cartesian product pairs every row in one table with every row in another; a join condition can restrict the result to matching pairs.
- Unqualified column names are ambiguous when multiple referenced tables contain the same column name.
- Table aliases make multi-table queries easier to read and maintain.
- `INNER JOIN` returns matching rows based on the condition specified in `ON`.
- `NATURAL JOIN` infers matching columns from shared names, which can make queries sensitive to schema changes.
- `LEFT JOIN` preserves all rows from the left table, even when no matching rows exist in the right table.
- An `INNER JOIN` excludes unmatched rows, while a `LEFT JOIN` can be used to identify them.
- The anti-join pattern uses `LEFT JOIN` with `IS NULL` to identify records without matching rows.
- A self-join allows a table to be joined with itself, such as when retrieving employees and their managers.
- `DISTINCT` eliminates duplicate result rows, which is useful when a record has multiple matching rows in another table.
- `WHERE` filters individual rows, while `HAVING` filters groups after aggregation.
- `COUNT(*)` counts joined rows, while `COUNT(column)` counts only non-NULL values. This distinction is important when using `LEFT JOIN`.
- `SUM(Qty)` counts units purchased, which is different from counting order details or distinct products.
- `GROUP BY` produces one aggregate result per group, such as one summary per category, order, customer, or department.
- A line-item subtotal can be calculated as `Qty * UnitPrice`; an order total can be calculated using `SUM(Qty * UnitPrice)`.
- `PurchaseUnitPrice` records the unit price associated with an order detail, allowing purchase totals to remain independent of subsequent changes to current product prices.
- `COALESCE()` can replace a NULL aggregate result with a specified value, such as zero.
- A view is a named query that can simplify the reuse of complex SQL statements.
- A regular MySQL view does not store a separate copy of its results. Changes to the underlying tables are reflected when the view is queried again, without recreating it.

**Important:** One statement intentionally produces an ambiguous-column error by comparing `CategoryID = CategoryID` after joining tables that both contain a `CategoryID` column. The corrected statement explicitly qualifies each column. Execute the demonstration statements individually and examine the error before proceeding.

Another demonstration intentionally contains a logic error when counting employees using `COUNT(*)` with `LEFT JOIN`. The following task corrects the count using `COUNT(EmployeeID)`. Compare the results to understand why departments without employees may otherwise be counted incorrectly.

## Getting Started

1. Open MySQL Workbench and connect to your MySQL server.
2. Open and execute `01 Create and Populate Grocery Database.sql` to create and populate the database.
3. Open `02 Join Operations.sql`.
4. Execute `USE grocery;` and `SHOW TABLES;` to select and inspect the database.
5. Run the numbered tasks in sequence, comparing the outputs of `CROSS JOIN`, filtered Cartesian products, `INNER JOIN`, and `LEFT JOIN`.
6. Examine the intentionally incorrect queries and then execute their corrected versions.
7. Continue through the product statistics and order-total calculations, observing how `GROUP BY` and `HAVING` change the results.
8. Explore multi-table joins and self-joins to retrieve information about customer purchases and employee reporting relationships.
9. Examine how `LEFT JOIN` preserves unmatched rows, and compare `COUNT(*)` with `COUNT(column)` when calculating employee counts.
10. Create and query the `ListOfCustomerSpending` view, then use `ORDER BY` and `LIMIT` to identify the highest-spending customer.

**Note:** The demonstration assumes that the `grocery` database and its sample records have already been created. Execute the setup script before running the queries.

The join operations script also includes an `ALTER TABLE` statement to add `PurchaseUnitPrice` to `OrderDetail`. **Skip this statement if the column already exists**, as attempting to add it again will produce an error. The subsequent `UPDATE` statement initializes purchase-time prices using the current product prices in the synthetic dataset.

The `CREATE VIEW` statement should also be executed only when the view does not already exist. A view does not need to be recreated when records in the underlying tables change.

## Database Overview

| Table | Description |
|---|---|
| `Category` | Stores product categories used to classify products. |
| `Department` | Stores organizational departments to which grocery store employees belong. |
| `Product` | Stores product information, including category associations and current unit prices. |
| `OrderDetail` | Stores individual order line items, including purchased products, quantities, and purchase-time unit prices. |
| `OnlineOrder` | Stores order-level information and associates orders with customers. |
| `Customer` | Stores customer information associated with orders. |
| `Employee` | Stores employee information, including department assignments, salaries, hiring dates, and reporting relationships. |

### Entity-Relationship Diagram

The following diagram illustrates the structure of the grocery database, including its tables, primary keys, foreign keys, and relationships.

![Grocery Database ER Diagram](images/grocery-erd.png)

## Requirements

- MySQL 8.0 or later
- MySQL Workbench (recommended)

## Disclaimer

All data provided in this repository is **synthetic and intended for educational purposes only**. The records do not represent actual customers, employees, transactions, or businesses. Any resemblance to real individuals or entities is purely coincidental.
