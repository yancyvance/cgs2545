
/*
Database Setup

Select the grocery database as the active database
for the following SQL demonstrations.

Display all tables in the database to review
the available tables before performing joins.
*/
USE grocery;

SHOW TABLES;


/*
Task 1: Examine the Category and Department Tables

Examine the records in the Category and Department tables.
Notice that these tables do not have a direct relationship.
*/

-- 9 rows
SELECT * FROM Category;

-- 12 rows
SELECT * FROM Department;


/*
Task 2: Demonstrate a Cartesian Product

Retrieve every possible combination of rows from Category
and Department using the implicit join syntax.

Since Category has 9 rows and Department has 12 rows,
the resulting Cartesian product contains 108 rows.
*/
SELECT * FROM Category, Department;


/*
Task 3: Perform an Explicit CROSS JOIN

Retrieve the same Cartesian product using CROSS JOIN.
Compare the results with the previous query.
*/
SELECT * FROM Category
CROSS JOIN Department;


/*
Task 4: Examine the Cartesian Product of Product and Category

Pair every product with every category, regardless of
whether the category actually belongs to the product.
*/
SELECT * FROM Product
CROSS JOIN Category;


/*
Task 5: Demonstrate an Ambiguous Column Reference

Attempt to filter the Cartesian product using CategoryID.

INTENTIONAL ERROR:
This query produces an ambiguous column error because
CategoryID exists in both Product and Category.

MySQL cannot determine which table's CategoryID is
being referenced.
*/
SELECT * FROM Product
CROSS JOIN Category
WHERE CategoryID = CategoryID;


/*
Task 6: Resolve the Ambiguous Column Reference

Qualify CategoryID using the corresponding table names.
Retain only combinations where the product's category ID
matches the category table's primary key.
*/
SELECT * FROM Product
CROSS JOIN Category
WHERE Product.CategoryID = Category.CategoryID;


/*
Task 7: Use Table Aliases

Rewrite the previous query using table aliases.
Use p for Product and c for Category.

Observe that aliases make column references shorter
while preserving the same matching condition.
*/
SELECT * FROM Product p
CROSS JOIN Category c
WHERE p.CategoryID = c.CategoryID;


/*
Task 8: Retrieve Selected Columns from Related Tables

Display the product ID, product name, unit price,
category ID, and category name.

Notice that the query retrieves columns from two tables
while retaining only rows satisfying the matching condition.
*/
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    p.CategoryID,
    c.CategoryName
FROM Product p
CROSS JOIN Category c
WHERE p.CategoryID = c.CategoryID;


/*
Task 9: Introduce INNER JOIN

Rewrite the previous matching operation using INNER JOIN.

Instead of filtering a Cartesian product using WHERE,
specify the matching condition directly using ON.

For an INNER JOIN, the matching row combinations are
equivalent to those produced by the previous approach.
*/
SELECT * FROM Product p
INNER JOIN Category c
    ON p.CategoryID = c.CategoryID;


/*
Task 10: Demonstrate NATURAL JOIN

Join Product and Category without explicitly specifying
a matching condition.

NATURAL JOIN automatically matches columns that share
the same name in both tables.

Although convenient, this approach is generally
discouraged because the matching columns are inferred
from the table structures.
*/
SELECT * FROM Product p
NATURAL JOIN Category c;


/*
Task 11: Retrieve Products from a Specific Category

List all products belonging to the Beverages category.
Use INNER JOIN to retrieve the corresponding category
information and WHERE to filter the results.

Sort by product ID in ascending order.
*/
SELECT * FROM Product p
INNER JOIN Category c
    ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
ORDER BY p.ProductID ASC;


/*
Task 12: Calculate Product Statistics for One Category

Determine the total number of products and their average
unit price for the Beverages category.

Name the resulting columns ProductCount and
ProductAveragePrice.

Since the query calculates statistics for a single
filtered set of rows, GROUP BY is not required.
*/
SELECT
    COUNT(*) AS ProductCount,
    AVG(p.UnitPrice) AS ProductAveragePrice
FROM Product p
INNER JOIN Category c
    ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages';


/*
Task 13: Calculate Product Statistics for Every Category

Extend the previous query to calculate the number of
products and average unit price for each category.

Group by CategoryID and sort by CategoryID in ascending
order.

CategoryName can be included because it is functionally
dependent on CategoryID, which is the primary key.

Categories without matching products will not appear
because the query uses INNER JOIN.
*/
SELECT
    c.CategoryID,
    c.CategoryName,
    COUNT(*) AS ProductCount,
    AVG(p.UnitPrice) AS ProductAveragePrice
FROM Product p
INNER JOIN Category c
    ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID
ORDER BY c.CategoryID;


/*
Task 14: Retrieve Products Purchased in a Specific Order

List the products purchased in order 1001.

Join OrderDetail with Product using ProductID to retrieve
the corresponding product information.

Each matching row represents an order detail.
*/
SELECT * FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
WHERE d.OrderID = 1001;


/*
Task 15: Calculate the Subtotal for Each Order Detail

For order 1001, calculate the subtotal of each line item
by multiplying the quantity purchased by the unit price.

Name the calculated column SubTotal.

Notice that the calculation uses columns from both
OrderDetail and Product.
*/
SELECT
    *,
    d.Qty*p.UnitPrice AS SubTotal
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
WHERE d.OrderID = 1001;


/*
Task 16: Calculate the Total Items and Grand Total

Determine the total number of units purchased and the
grand total for order 1001.

Name the resulting columns TotalItems and GrandTotal.

SUM(Qty) calculates the total number of units purchased,
not the number of distinct products or order details.

SUM(Qty * UnitPrice) calculates the total monetary amount.
*/
SELECT
    SUM(d.Qty) AS TotalItems,
    SUM(d.Qty*p.UnitPrice) AS GrandTotal
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
WHERE d.OrderID = 1001;


/*
Task 17: Calculate Totals for All Orders

Extend the previous query to calculate the total number
of items and grand total for every order.

Group by OrderID so that each order produces one row.
Sort the results by OrderID in ascending order.
*/
SELECT
    d.OrderID,
    SUM(d.Qty) AS TotalItems,
    SUM(d.Qty*p.UnitPrice) AS GrandTotal
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
GROUP BY d.OrderID
ORDER BY d.OrderID;


/*
Task 18: Identify Orders with a Minimum Grand Total

List only orders whose grand total is at least $100.

Display OrderID, TotalItems, and GrandTotal.
Sort by OrderID in ascending order.

Use HAVING rather than WHERE because the condition
depends on the aggregated grand total.

MySQL allows the alias GrandTotal to be referenced
in the HAVING clause.
*/
SELECT
    d.OrderID,
    SUM(d.Qty) AS TotalItems,
    SUM(d.Qty*p.UnitPrice) AS GrandTotal
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
GROUP BY d.OrderID
HAVING GrandTotal >= 100
ORDER BY d.OrderID;
