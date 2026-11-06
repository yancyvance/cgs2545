
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


/*
Task 19: Retrieve Unique Products Purchased by a Customer

List the IDs and names of all distinct products purchased
by customer 4.

Use multiple INNER JOIN operations and sort by ProductID.
*/
SELECT DISTINCT
    p.ProductID,
    p.ProductName
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
WHERE o.CustomerID = 4
ORDER BY p.ProductID;


/*
Task 20: Retrieve Products Purchased by Customers in Florida

List the IDs and names of all distinct products purchased
by customers living in Florida (FL).

Join the four related tables and sort by ProductID.
*/
SELECT DISTINCT
    p.ProductID,
    p.ProductName
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
INNER JOIN Customer c
    ON c.CustomerID = o.CustomerID
WHERE c.State = 'FL'
ORDER BY p.ProductID;


/*
Task 21: Count Unique Products Purchased by Each Customer

Determine the number of distinct products purchased
by each customer.

Display CustomerID and UniqueProductCount.
*/
SELECT
    o.CustomerID,
    COUNT(DISTINCT d.ProductID) AS UniqueProductCount
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
GROUP BY o.CustomerID;


/*
Task 22: Calculate Customer Spending

Calculate the total amount spent by each customer using
the current product prices.

Display only customers whose total spending is at least $1000.

Note that customers without orders are excluded.
*/
SELECT
    o.CustomerID,
    SUM(p.UnitPrice * d.Qty) AS TotalSpent
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
INNER JOIN Product p
    ON d.ProductID = p.ProductID
GROUP BY o.CustomerID
HAVING TotalSpent >= 1000;


/*
Task 23: Sort Customers by Their Total Spending

List customers whose total spending is at least $1000.

Display CustomerID and TotalSpent.
Sort by CustomerID in ascending order.
*/
SELECT
    o.CustomerID,
    SUM(p.UnitPrice * d.Qty) AS TotalSpent
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
INNER JOIN Product p
    ON d.ProductID = p.ProductID
GROUP BY o.CustomerID
HAVING TotalSpent >= 1000
ORDER BY o.CustomerID ASC;


/*
Task 24: Examine the Current Order Pricing Design

List order details alongside their product information.

Consider what happens to historical order totals
when the current product price changes.
*/
SELECT *
FROM OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID;


/*
Reminder: Add PurchaseUnitPrice to OrderDetail

If you missed the earlier schema modification, execute
the ALTER TABLE statement below before proceeding.

PurchaseUnitPrice stores the unit price of a product
at the time of purchase, rather than its current price.

IMPORTANT: Skip this statement if PurchaseUnitPrice
already exists in your OrderDetail table.
*/
ALTER TABLE OrderDetail
ADD COLUMN PurchaseUnitPrice DECIMAL(10,2);


/*
Task 25: Populate Purchase-Time Unit Prices

Populate OrderDetail.PurchaseUnitPrice using the
corresponding product's current unit price.

Use UPDATE with INNER JOIN.

For this sample dataset, current prices are used
to initialize the purchase-time prices.
*/
UPDATE OrderDetail d
INNER JOIN Product p
    ON d.ProductID = p.ProductID
SET d.PurchaseUnitPrice = p.UnitPrice;


/*
Task 26: Verify the Updated Order Details

Display all order details to confirm that
PurchaseUnitPrice has been populated.
*/
SELECT * FROM OrderDetail;


/*
Task 27: Examine All Employees

List all employees and determine the total number
of employees in the database.

Keep this count in mind for the next task.
*/
SELECT * FROM Employee;

SELECT COUNT(*) AS EmployeeCount
FROM Employee;


/*
Task 28: Introduce Employee Self-Joins

List employees along with their managers' first
and last names.

Use INNER JOIN on the Employee table.

Compare the number of returned rows with Task 27.
Why are some employees missing?
*/
SELECT
    e.*,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName
FROM Employee e
INNER JOIN Employee m
    ON e.ManagerID = m.EmployeeID;


/*
Task 29: Include Employees Without Managers

List all employees and their manager information,
including employees without an assigned manager.

Use LEFT JOIN and compare the results with Task 27.
*/
SELECT *
FROM Employee e
LEFT JOIN Employee m
    ON e.ManagerID = m.EmployeeID;


/*
Task 30: Count Direct Reports per Manager

List the IDs of employees who supervise other employees,
along with the number of their direct reports.

Name the count column EmployeeCount.
*/
SELECT
    m.EmployeeID AS ManagerID,
    COUNT(*) AS EmployeeCount
FROM Employee m
INNER JOIN Employee e
    ON m.EmployeeID = e.ManagerID
GROUP BY m.EmployeeID;


/*
Task 31: Identify Employees Without Assigned Managers

List employees whose ManagerID is NULL.

Is a JOIN necessary for this query?
*/
SELECT *
FROM Employee
WHERE ManagerID IS NULL;


/*
Task 32: Identify Employees Without Matching Managers

Use LEFT JOIN to identify employees who do not
have a matching manager record.

Compare the results with Task 31.
*/
SELECT *
FROM Employee e
LEFT JOIN Employee m
    ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IS NULL;
