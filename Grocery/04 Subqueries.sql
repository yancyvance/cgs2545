
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
Use SUM(Qty) to count the total units purchased,
including multiple units within a single order.
*/
SELECT DISTINCT
    o.CustomerID
FROM OrderDetail d
INNER JOIN OnlineOrder o
    ON d.OrderID = o.OrderID
GROUP BY o.CustomerID, d.ProductID
HAVING SUM(Qty) > 1;


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
    SELECT CustomerID FROM OnlineOrder
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
    SELECT CustomerID FROM OnlineOrder
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



/*
Task 13: Rewrite Task 10 using a correlated subquery
with EXISTS. List employees who have processed at least
one order. Compare this approach with IN.

EXISTS returns TRUE if the subquery produces at least
one row, and FALSE otherwise. It does not depend on
the values returned by the subquery.

A correlated subquery is conceptually similar to nested
loops in programming: for each row in the outer query,
the inner query is evaluated using that row's values.
This may be slower than a non-correlated subquery,
although MySQL can optimize its execution.
*/
SELECT * FROM Employee;

SELECT * FROM OnlineOrder;

SELECT * FROM Employee e
WHERE EXISTS
(
    SELECT * FROM OnlineOrder o
    WHERE o.EmpID = e.EmployeeID
);


/*
Task 14: List employees who have not processed any orders
using NOT EXISTS.
Compare this approach with the NOT IN solution from
Tasks 11 and 12. How does NOT EXISTS handle NULL values?
*/
SELECT * FROM Employee e
WHERE NOT EXISTS
(
    SELECT * FROM OnlineOrder o
    WHERE o.EmpID = e.EmployeeID
);


/*
Task 15: List all employees along with the overall
average annual salary, labeled AvgSalary.
First, review how AVG() calculates a single aggregate
result. Then use a scalar subquery in the SELECT clause
to display the average alongside each employee.
*/
SELECT AVG(AnnualSalary) FROM Employee;

SELECT
    *,
    ( SELECT AVG(AnnualSalary) FROM Employee ) AS AvgSalary
FROM Employee;


/*
Task 16: Extend Task 15 by calculating the difference
between each employee's salary and the overall average.
Label the calculated column DiffAvgSalary.
*/
SELECT
    *,
    ( SELECT AVG(AnnualSalary) FROM Employee ) AS AvgSalary,
    AnnualSalary - ( SELECT AVG(AnnualSalary) FROM Employee ) AS DiffAvgSalary
FROM Employee;


/*
Task 17: Rewrite Task 16 using a derived table.
Calculate AvgSalary in the inner query, then use
its alias to calculate DiffAvgSalary in the outer query.
*/
SELECT
    *,
    AnnualSalary-AvgSalary AS DiffAvgSalary
FROM
(
    SELECT
        *,
        ( SELECT AVG(AnnualSalary) FROM Employee ) AS AvgSalary
    FROM Employee
) res;


/*
Task 18: List all employees along with the average
annual salary of employees in their department.
Use a correlated scalar subquery and label the
calculated column DeptAvgSalary.
*/
SELECT
    *,
    (
        SELECT AVG(AnnualSalary)
        FROM Employee e2
        WHERE e2.DeptID = e.DeptID
    ) AS DeptAvgSalary
FROM Employee e;


/*
Task 19: List employees whose annual salary exceeds
the average salary of their department.
First, attempt to reference the DeptAvgSalary alias
in the WHERE clause. Why does this produce an error?
*/
SELECT
    *,
    (
        SELECT AVG(AnnualSalary)
        FROM Employee e2
        WHERE e2.DeptID = e.DeptID
    ) AS DeptAvgSalary

FROM Employee e
WHERE AnnualSalary > DeptAvgSalary;


/*
Task 20: Correct Task 19 using a derived table.
Calculate DeptAvgSalary in the inner query, then
filter employees in the outer query using the alias.
*/
SELECT * FROM
(
    SELECT
        *,
        (
            SELECT AVG(AnnualSalary)
            FROM Employee e2
            WHERE e2.DeptID = e.DeptID
        ) AS DeptAvgSalary

    FROM Employee e
) res
WHERE res.AnnualSalary > res.DeptAvgSalary;


/*
Task 20: Revisit the join exercise involving customers
who have never placed an order in 2025.
First, review the LEFT JOIN solution, then explore
two alternative approaches using subqueries.
*/
-- Original approach: LEFT JOIN
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customer c
LEFT JOIN OnlineOrder o
    ON c.CustomerID = o.CustomerID
    AND YEAR(o.OrderDate) = 2025
WHERE o.OrderID IS NULL;

-- Approach A: NOT IN
-- This works because CustomerID in OnlineOrder is
-- required (NOT NULL), so the subquery cannot return NULL.
SELECT * FROM Customer c
WHERE CustomerID NOT IN (
    SELECT CustomerID FROM OnlineOrder
    WHERE YEAR(OrderDate) = 2025
);

-- Approach B: NOT EXISTS
-- Uses a correlated subquery to check for matching orders.
-- Unlike NOT IN, it is not affected by NULL values
-- returned by the subquery.
SELECT * FROM Customer c
WHERE NOT EXISTS
(
    SELECT * FROM OnlineOrder o
    WHERE o.CustomerID = c.CustomerID
        AND YEAR(OrderDate) = 2025
);


/*
Task 21 (Puzzle): List all orders that were the only
orders shipped on their respective shipping dates.

Idea: Consider two instances of OnlineOrder. For each
order in the first instance, check whether another order
in the second instance was shipped on the same date.
Exclude comparisons involving the same order.

Use a correlated subquery with NOT EXISTS to ensure
no other order was shipped on the same date.
Exclude orders that have not yet been shipped.
*/
SELECT
    *
FROM OnlineOrder o1
WHERE NOT EXISTS
(
    SELECT * FROM OnlineOrder o2
    WHERE DATE(o2.ShipDate) = DATE(o1.ShipDate)
        AND o2.OrderID != o1.OrderID
)
    AND o1.ShipDate IS NOT NULL;