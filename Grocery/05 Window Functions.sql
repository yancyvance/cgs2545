
/*
Database Setup

Select the grocery database as the active database
for the following SQL demonstrations.
*/
USE grocery;


/*
Task 1: Create a view called ListOfAllOrders that
displays all orders along with their calculated
grand totals.

Use LEFT JOIN to include orders without any order
details. Calculate GrandTotal using SUM() and
COALESCE() to treat missing values as zero.

This view will be used in subsequent demonstrations
of window functions.
*/
CREATE VIEW ListOfAllOrders AS
SELECT
    o.*,
    SUM( COALESCE( d.Qty*d.PurchaseUnitPrice, 0 ) ) AS GrandTotal
FROM OnlineOrder o
LEFT JOIN OrderDetail d
    ON o.OrderID = d.OrderID
GROUP BY o.OrderID;


/*
Task 2: Compare the original OnlineOrder table with
the ListOfAllOrders view.

Observe that the view includes an additional
GrandTotal column while preserving all orders,
including those without order details.
*/
SELECT * FROM OnlineOrder;

SELECT * FROM ListOfAllOrders;
