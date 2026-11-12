
/*
Database Setup

Select the grocery database as the active database
for the following SQL demonstrations.
*/
USE grocery;


/*
Task 1: List the IDs and names of all employees,
along with the names of their departments.
Include only employees assigned to a department.
*/
-- INNER



/*
Task 2: List the IDs and names of all employees,
along with the names of their departments.
Include employees who are not assigned to a department.
*/
-- LEFT



/*
Task 3: List all department IDs and names,
along with the IDs of their employees.
Include departments that currently have no employees.
*/
-- LEFT



/*
Task 4: List the IDs and names of customers who
have placed at least one order.
Display each customer only once.
*/
-- INNER
SELECT DISTINCT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customer c
INNER JOIN OnlineOrder o
    ON c.CustomerID = o.CustomerID;



/*
Task 5: List the IDs and names of all customers,
along with the number of orders they have placed.
Include customers who have never placed an order.
*/
-- LEFT
SELECT
    c.CustomerID,
    COUNT(o.OrderID) AS OrderCount
FROM Customer c
LEFT JOIN OnlineOrder o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;



/*
Task 6: List all products that have been purchased
at least once. Display ProductID and ProductName.
Each product should appear only once.
*/
-- INNER



/*
Task 7: List all products that have never been
purchased. Display ProductID and ProductName.
*/
-- LEFT
SELECT * FROM Product p
LEFT JOIN OrderDetail d
    ON p.ProductID = d.ProductID
WHERE d.OrderDetailID IS NULL;



/*
Task 8: List the IDs and names of all employees,
along with the IDs and names of their managers.
Include employees who do not have a manager.
*/
-- LEFT (self join)



/*
Task 9: List all department IDs and names,
along with their average employee salary.
Include departments without employees.
*/
-- LEFT



/*
Task 10: List all customers who have never
placed an order in 2025.
Display CustomerID, FirstName, and LastName.
NOTE: During the lecture, we used 2026. I changed
it to 2025 instead so that you can see the difference.
*/
-- LEFT
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customer c
LEFT JOIN OnlineOrder o
    ON c.CustomerID = o.CustomerID
    AND YEAR(o.OrderDate) = 2025
WHERE o.OrderID IS NULL;