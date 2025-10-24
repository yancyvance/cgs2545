-- what items cost less than 10$?
SELECT * FROM Product
    WHERE UnitPrice < 10;
    
-- what orders were place on 10/1/2025?
SELECT * FROM OnlineOrder
    WHERE OrderDate = '2025-10-01';
    
    
-- list all orders that do not have a shipping date yet
SELECT * FROM OnlineOrder
    WHERE ShipDate IS NULL;
    

-- list all orders that were already delivered and paid for
-- by the customer using a credit card
SELECT * FROM OnlineOrder
    WHERE OrderStatus = 'Delivered'
        AND (PaymentMethod = 'Credit Card'
            OR PaymentMethod = 'Paypal');
            
            
-- list all orders by a customer
SELECT * FROM OnlineOrder
    WHERE CustomerID = 1102;
    
-- list all the products or items that contain the word "milk"
SELECT * FROM Product
    WHERE ProductName LIKE '%milk%';


-- list all customers whose first name begin with A
SELECT * FROM Customer
    WHERE FirstName LIKE 'A%'
        COLLATE utf8mb4_bin;
        
-- list all customers whose 3rd digit of their zip code is a 2
SELECT * FROM Customer
    WHERE Zipcode LIKE '__2%';
    
    
-- list all customers who are from FL or AZ
SELECT * FROM Customer
    WHERE State IN ('FL', 'AZ');
    
SELECT * FROM Customer
    WHERE State = 'FL'
        OR State = 'AZ';
        
-- list all products whose price is 10-20, inclusive
SELECT * FROM Product
    WHERE UnitPrice >= 10 AND UnitPrice <= 20;

SELECT * FROM Product
    WHERE UnitPrice BETWEEN 10 AND 20;


SELECT ProductName, ProductID AS ItemID, UnitPrice, Category,
    (UnitPrice*1.06) AS PriceAfterTax
        FROM Product;

SELECT ProductName, ProductID AS ItemID, UnitPrice,
    Category, ROUND(UnitPrice*1.06, 2) AS PriceAfterTax
        FROM Product
            WHERE ROUND(UnitPrice*1.06, 2) > 10
                ;


-- Display all existing columns, and include an additional computed column named Taxable 
-- that indicates whether the item is not in the categories 'Produce' or 'Dairy'.
SELECT *, IF(Category = 'Produce' OR Category = 'Dairy', 0, 1) AS Taxable
    FROM Product;
    
SELECT *, IF(Category IN ('Produce', 'Dairy'), 0, 1) AS Taxable
    FROM Product;
    
-- add a virtual column which concatenates the first name and last name of a customer
SELECT CustomerID, FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName FROM Customer;



-- list all customers and arrange them according to State, city, last name, first name
SELECT * FROM Customer
    ORDER BY State, City, LastName, FirstName DESC;
    
    
SELECT * FROM Customer
    WHERE ContactNo LIKE '2%';


-- list all the order ids in which the following product IDS were sold: 2039, 2050,  2066
SELECT DISTINCT OrderID FROM OrderDetail
    WHERE ProductID IN (2039, 2050, 2066)
        ORDER BY OrderID;


SELECT COUNT( DISTINCT OrderID ) FROM OrderDetail
    WHERE ProductID IN (2039, 2050, 2066)
        ORDER BY OrderID;
    
SELECT COUNT( DISTINCT OrderID ) FROM OrderDetail
    WHERE ProductID IN (2039, 2050, 2066)
        ORDER BY OrderID;
        
-- list all the items ids that were sold in the past
SELECT DISTINCT ProductID FROM OrderDetail;


-- from which states are the customers from?
SELECT DISTINCT State FROM Customer
    ORDER BY State;


  
-- how many customers are there in the database
SELECT COUNT(*) FROM Customer;


-- break down the number of customers by state
SELECT State, COUNT(*) AS CustomerCount FROM Customer
    GROUP BY State
        HAVING CustomerCount >= 10
            ORDER BY CustomerCount;
    

-- list all product ids along with the total quantity sold. include only those
-- with quantity sold that is between 10 and 20 (inclusive)
SELECT ProductID, SUM(Qty) AS QtySold FROM OrderDetail
    GROUP BY ProductID
        HAVING QtySold BETWEEN 10 AND 20
            ORDER BY QtySold DESC, ProductID;
        

-- list all the customers whose first name and last name begin with the same letter
SELECT CustomerID, FirstName, LastName FROM Customer
    WHERE LEFT(FirstName, 1) = LEFT(LastName, 1);
    
-- list all customers whose first name begins and ends with the same letter
SELECT CustomerID, FirstName FROM Customer
    WHERE LEFT(FirstName, 1) = RIGHT(FirstName, 1);
    
SELECT FirstName, MID(FirstName, 2, 2) FROM Customer;

-- list all the customers whose first name is 5 letters long and begins with a vowel
SELECT DISTINCT CustomerID, FirstName FROM Customer
    WHERE CHAR_LENGTH(FirstName) = 5
        AND LEFT(FirstName, 1) IN ('A', 'E', 'I', 'O', 'U')
            ORDER BY FirstName;



-- list all the order IDs that were shipped between 9/22/25 and 9/26/25, inclusive
SELECT OrderID, ShipDate FROM OnlineOrder
    -- WHERE ShipDate >= '2025-09-22 00:00:00' AND ShipDate < '2025-09-27 00:00:00'
    WHERE ShipDate BETWEEN '2025-09-22 00:00:00' AND '2025-09-26 23:59:59'
        ORDER BY ShipDate DESC;


-- on what date was the first order placed
SELECT OrderID, OrderDate FROM OnlineOrder
    ORDER BY OrderDate
        LIMIT 1;
    
    
SELECT NOW();
SELECT CURDATE();
        
-- list all the orders placed this month
SELECT *, MONTH(OrderDate), YEAR(OrderDate) FROM OnlineOrder
    WHERE YEAR(OrderDate) = YEAR( CURDATE() )
        AND MONTH(OrderDate) = MONTH( CURDATE() );

SELECT DATE_FORMAT( CURDATE(), '%Y-%m-01' ) + INTERVAL 1 MONTH;

SELECT * FROM OnlineOrder
    WHERE OrderDate >= DATE_FORMAT( CURDATE(), '%Y-%m-01' ) 
        AND OrderDate < DATE_FORMAT( CURDATE(), '%Y-%m-01' ) + INTERVAL 1 MONTH;
        
        
-- list all orders placed during first quarter of this year
SELECT * FROM OnlineOrder
    WHERE OrderDate >= DATE_FORMAT( CURDATE(), '%Y-01-01' ) 
        AND OrderDate < DATE_FORMAT( CURDATE(), '%Y-05-01' )
            ORDER BY OrderDate;
            

SELECT MONTH(OrderDate) AS OrderMonth, COUNT(*) AS OrderCount FROM OnlineOrder
    GROUP BY MONTH(OrderDate)
        ORDER BY COUNT(*) DESC;
        
-- list the total quantity sold of all items b
SELECT OrderID, SUM(Qty) AS QtySold FROM OrderDetail
    GROUP BY OrderID;
    
-- how many unique customers have pending orders?
SELECT COUNT(DISTINCT CustomerID) FROM OnlineOrder
    WHERE OrderStatus = 'Pending'
        ORDER BY CustomerID;
        
        
SELECT *, IF(ShipDate IS NULL, OrderDate, ShipDate) AS LastActivityDate FROM OnlineOrder;

SELECT *, IFNULL(ShipDate, OrderDate) AS LastActivityDate FROM OnlineOrder;

SELECT *, COALESCE(ShipDate, OrderDate) AS LastActivityDate FROM OnlineOrder;



-- Categorize the orders based on payment method: Internal (Credit/Debit Cards) or External (Gift Card/Paypal)
SELECT *,
    CASE PaymentMethod
        WHEN 'Credit Card' THEN 'Internal'
        WHEN 'Debit Card' THEN 'Internal'
        ELSE 'External'
    END AS PaymentProcessType
FROM OnlineOrder;



-- Categorize products based on its price: Low, Mid, High
CREATE VIEW ProductPrices AS
SELECT *,
    CASE
        WHEN UnitPrice < 10 THEN 'Low'
        WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Mid'
        ELSE 'High'
    END AS PriceGroup,
    Category NOT IN ('Produce', 'Dairy') AS Taxable,
    UnitPrice* (1 + .06 * (Category NOT IN ('Produce', 'Dairy')) ) AS PriceAfterTax
FROM Product;


-- Incorporate the information about being Taxable or not AND the price after tax
SELECT *,
    CASE
        WHEN UnitPrice < 10 THEN 'Low'
        WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Mid'
        ELSE 'High'
    END AS PriceGroup,
    Category NOT IN ('Produce', 'Dairy') AS Taxable,
    UnitPrice* (1 + .06 * (Category NOT IN ('Produce', 'Dairy')) ) AS PriceAfterTax
FROM Product;


-- create a view from the query above
CREATE VIEW ProductPrices AS
SELECT *,
    CASE
        WHEN UnitPrice < 10 THEN 'Low'
        WHEN UnitPrice BETWEEN 10 AND 20 THEN 'Mid'
        ELSE 'High'
    END AS PriceGroup,
    Category NOT IN ('Produce', 'Dairy') AS Taxable,
    UnitPrice* (1 + .06 * (Category NOT IN ('Produce', 'Dairy')) ) AS PriceAfterTax
FROM Product;



-- list all products that are not taxable and belong to the high price group (using views)
SELECT * FROM ProductPrices
    WHERE PriceGroup = 'High'
        AND NOT Taxable;
