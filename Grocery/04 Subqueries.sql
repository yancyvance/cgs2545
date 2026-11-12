
/*
Database Setup

Select the grocery database as the active database
for the following SQL demonstrations.
*/
USE grocery;


-- SECTION 1: SQL PUZZLES

/*
Task 1: List all customers who share both their first
and last names with at least one other customer.
Use GROUP BY and HAVING to identify duplicate names.
*/
SELECT
    FirstName, LastName, COUNT(*)
FROM Customer
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1;


/*
Task 2: List the IDs of customers who bought the same
item multiple times, whether within a single order
or across different orders.
Use COUNT(*) to count matching order-detail records,
not the total quantity purchased.
*/
SELECT DISTINCT
    o.CustomerID
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
GROUP BY o.CustomerID, d.ProductID
HAVING COUNT(*) > 1;


/*
Task 3: List the IDs of customers who bought the same
item multiple times across different orders.
Use COUNT(DISTINCT OrderID) to count different orders
containing the same product.
*/
SELECT DISTINCT
    o.CustomerID
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
GROUP BY o.CustomerID, d.ProductID
HAVING COUNT(DISTINCT o.OrderID) > 1;



-- SECTION 2: SUBQUERIES

/*
Task 4: Examine all employees and calculate their
average annual salary using AVG().
*/
SELECT * FROM Employee;

SELECT AVG(AnnualSalary) FROM Employee;


/*
Task 5: List employees whose annual salary exceeds
the company average.
Use the previously calculated average as a fixed value.
What happens if employee salaries change?
*/
SELECT * FROM Employee
WHERE AnnualSalary > 69716.667;


/*
Task 6: Rewrite Task 5 using a scalar subquery.
The inner query calculates the average salary, while
the outer query retrieves employees earning above it.
*/
SELECT * FROM Employee
WHERE AnnualSalary > (
    SELECT AVG(AnnualSalary) FROM Employee
);


/*
Task 7: List customers who have placed at least one order.
Use IN with a subquery to identify matching customers.
DISTINCT is unnecessary inside IN because duplicate
values do not affect membership testing.
*/
SELECT DISTINCT CustomerID FROM OnlineOrder;

SELECT * FROM Customer
WHERE CustomerID IN
(
    SELECT DISTINCT CustomerID FROM OnlineOrder
);


/*
Task 8: List customers who have never placed an order.
Use NOT IN to exclude customers appearing in OnlineOrder.
DISTINCT is also unnecessary for NOT IN.
Compare this approach with LEFT JOIN and IS NULL.
*/
SELECT * FROM Customer
WHERE CustomerID NOT IN
(
    SELECT DISTINCT CustomerID FROM OnlineOrder
);

-- NOTE: CustomerID in OnlineOrder is required (NOT NULL),
-- so the subquery cannot return NULL for this column.


/*
Task 9: Investigate how NULL affects the NOT IN operator.
Compare the results of the following expressions.
The third expression returns NULL (UNKNOWN) because
the list contains NULL and no matching value is found.
*/
SELECT 1 NOT IN (1, 2, 3);

SELECT 4 NOT IN (1, 2, 3);

SELECT 4 NOT IN (1, 2, 3, NULL);


/*
Task 10: List employees who have handled at least one order.
First, examine the distinct employee IDs in OnlineOrder.
Then use IN to retrieve the corresponding employees.

NOTE: EmpID in OnlineOrder is optional (nullable), so
some orders may not be associated with an employee.
*/
SELECT DISTINCT EmpID FROM OnlineOrder;

SELECT * FROM Employee
WHERE EmployeeID IN
(
    SELECT DISTINCT EmpID FROM OnlineOrder
);


/*
Task 11: List employees who have not processed any orders.
Use NOT IN to exclude employees appearing in OnlineOrder.
Since EmpID is nullable, the subquery may return NULL.
What happens to the results when NULL is present?
*/
SELECT * FROM Employee
WHERE EmployeeID NOT IN
(
    SELECT DISTINCT EmpID FROM OnlineOrder
);


/*
Task 12: Correct Task 11 by preventing NULL values
from affecting the NOT IN comparison.
Compare two approaches: replacing NULL with a special
value using COALESCE(), and excluding NULL values
using IS NOT NULL.
*/

-- Approach 1: Replace NULL with a special value
-- Assumption: -1 is not a valid EmployeeID.
SELECT * FROM Employee
WHERE EmployeeID NOT IN
(
    SELECT DISTINCT COALESCE(EmpID, -1) FROM OnlineOrder
);

-- Approach 2: Exclude NULL values from the subquery
SELECT * FROM Employee
WHERE EmployeeID NOT IN
(
    SELECT DISTINCT EmpID FROM OnlineOrder
    WHERE EmpID IS NOT NULL
);
