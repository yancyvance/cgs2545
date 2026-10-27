
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


### 4. `04 Intermediate Select Statements.sql`

This script continues the SQL querying activities introduced in
`03 Basic Select Statements.sql`, building on filtering, logical operators,
sorting, and handling `NULL` values. It progresses from pattern matching,
scalar functions, calculated columns, and date expressions to conditional
expressions, aggregate functions, grouped summaries, and filtering groups.

The examples use the `Course`, `Student`, and `Registration` tables to
retrieve, transform, classify, and summarize data without modifying the
underlying records. The script includes guided comparisons, intentionally
incorrect queries, corrected alternatives, and a concluding exercise reserved
for a later lesson on multi-table queries.

Topics covered include:

- **Pattern matching:** Using `LIKE` and `NOT LIKE` with `%` and `_` wildcards, including combined exclusion conditions.
- **Logical errors:** Comparing incorrect and corrected `AND`/`OR` conditions that may execute successfully but return unintended results.
- **Scalar functions:** Using `SUBSTRING()`, `CONCAT()`, and `CHAR_LENGTH()` to extract, combine, and measure text.
- **Calculated columns and type conversion:** Creating expressions with aliases and using `CAST()` to derive numeric course levels.
- **Column aliases:** Using aliases in `ORDER BY` and understanding why `WHERE` cannot reference a `SELECT` alias at the same query level.
- **Duplicate elimination:** Using `DISTINCT` on individual columns and entire selected rows, including `NULL` values.
- **Handling `NULL`:** Understanding three-valued comparisons and using `IS NULL`, `IS NOT NULL`, `IFNULL()`, and `COALESCE()`.
- **Date comparisons and functions:** Using inclusive and exclusive date boundaries, `BETWEEN`, `YEAR()`, `MONTH()`, `CURDATE()`, and `TIMESTAMPDIFF()`.
- **Arithmetic and date-related conditions:** Calculating course levels and ages, and identifying leap years using logical expressions.
- **Sorting and limiting results:** Using multiple `ORDER BY` criteria and `LIMIT`, including the implications of unspecified tie-breaking.
- **Conditional expressions:** Using simple and searched `CASE` expressions to calculate grade points and classify grades, and MySQL's `IF()` function to label student status.
- **Aggregate functions:** Using `COUNT(*)`, `COUNT(column)`, `MIN()`, `MAX()`, `SUM()`, and `AVG()` to summarize registrations and course credit hours.
- **Grouping results:** Using `GROUP BY` with one or multiple columns to summarize academic years, semesters, students, and departments.
- **Filtering groups:** Using `HAVING` with aggregate conditions and comparing it with `WHERE`, including MySQL's support for aliases in `HAVING`.
- **Calculated aggregate measures:** Computing graded and ungraded proportions with arithmetic and `ROUND()`.
- **Conditional aggregation:** Counting grades by leading letter using `SUM()` with Boolean expressions, while considering the effects of `NULL` values.

#### Key Takeaways

- `LIKE` and `NOT LIKE` use `%` to match zero or more characters and `_` to match exactly one character. Logical operators must be chosen carefully when combining patterns.
- Scalar functions and calculated columns transform query results without changing stored values. `CAST()` converts compatible values between data types.
- `SELECT` aliases can be referenced in `ORDER BY`, but not in `WHERE` at the same query level. MySQL also permits aliases in `GROUP BY` and `HAVING`.
- `DISTINCT` removes duplicate selected rows, while comparisons involving `NULL` generally produce `UNKNOWN`. `IFNULL()` and `COALESCE()` provide fallback values without modifying records.
- Date functions extract components or calculate elapsed time. `TIMESTAMPDIFF(YEAR, ...)` accounts for whether a birthday has passed, unlike simple birth-year subtraction.
- `ORDER BY` determines result ordering; `LIMIT` without a sufficient tie-breaker may return any of the tied rows.
- Simple and searched `CASE` expressions assign results based on matching values or conditions. MySQL's `IF()` offers another way to return one of two values.
- `COUNT(*)` counts rows, while `COUNT(column)` excludes rows where that column is `NULL`. `MIN()`, `MAX()`, `SUM()`, and `AVG()` summarize values.
- `WHERE` filters individual rows before grouping. `GROUP BY` forms groups, and `HAVING` filters those groups based on aggregate conditions.
- Grouping by multiple columns creates a group for each distinct combination of those values.
- Completion rates expressed as proportions range from 0 to 1; percentages range from 0 to 100. Rounding should be applied to the displayed result rather than prematurely to the underlying calculation.
- MySQL can sum Boolean comparisons to count matching rows, but `NULL` comparisons can yield `NULL` totals. `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` is a more portable alternative that returns zero when there are no matches in a nonempty group.

**Important:** The script deliberately includes examples of common SQL mistakes:

- Using `OR` instead of `AND` when excluding course titles containing either of two words.
- Referring to a calculated course-level or birth-year alias in `WHERE` at the same query level.
- Estimating age by subtracting birth years without accounting for whether the birthday has occurred.
- Attempting to use `COUNT(*)` in `WHERE` instead of filtering aggregate groups with `HAVING`.

Corrected queries or explanations accompany these examples for classroom comparison.


## Getting Started

1. Open MySQL Workbench and connect to your MySQL server.
2. Open `01 Create University Database.sql`.
3. Execute the SQL statements incrementally, following the comments and observing the expected errors.
4. Once the demonstration is complete, open `02 Sample Database Data.sql`.
5. Execute the sample data script to populate the database with additional records.
6. Open `03 Basic Select Statements.sql`.
7. Continue with `04 Intermediate Select Statements.sql` to explore pattern matching, scalar and date functions, conditional expressions, aggregate calculations, `GROUP BY`, `HAVING`, and conditional aggregation.
8. Execute the queries individually, observe the results, and review how each query demonstrates a particular SQL concept.

**Note:** Execute the scripts in the order indicated by their filenames. The data and query scripts assume that the university database and its tables have already been created.

## Database Overview

| Table | Description |
|---|---|
| `Student` | Stores student information, including declared majors and enrollment status. |
| `Course` | Stores course information, including course codes, titles, and credit hours. |
| `Registration` | Stores course registrations, semesters, academic years, and grades. |
| `Department` | Stores academic departments associated with courses. |

### Entity-Relationship Diagram

The following diagram illustrates the structure of the university database, including its tables, primary keys, foreign keys, and relationships.

![University Database ER Diagram](images/university-erd.png)

**Note:** The diagram represents the final database structure after the schema modifications demonstrated in `01 Create University Database.sql`.

## Requirements

- MySQL 8.0 or later
- MySQL Workbench (recommended)

## Disclaimer

All data provided in this repository is **synthetic and intended for educational purposes only**. The records do not represent actual individuals or institutional records. Any resemblance to real individuals or entities is purely coincidental.
