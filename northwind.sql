-- Project Goal: To see if there are opportunities to increase revenue by offering fewer discounts.

-- 1. Total Discount (understand the total amount of money spent on discounts)

SELECT ROUND(SUM(Discount*UnitPrice*Quantity),2) AS TotalDiscount FROM OrderDetail

-- 2. Discounts by order 
--   - list of orders along with the OrderID, the total amount of money spent on discounts for this order,
--     how much money the customer would have spent if the items in the order hadn’t been discounted, the ratio of the two

SELECT OrderID,
SUM(Discount*UnitPrice*Quantity) AS DiscountSpend,
SUM(UnitPrice*Quantity) AS UndiscountedRevenue,
SUM(Discount*UnitPrice*Quantity)/SUM(UnitPrice*Quantity) AS AvgDiscount

FROM OrderDetail
GROUP BY OrderID
ORDER BY DiscountSpend DESC

-- 3. Discounts by customer 
--  - list of orders along with CustomerID, the total amount of money spent on discounts for all orders made by this customer,
--    how much money the customer would have spent on these orders if the items hadn’t been discounted, the ratio of the two

SELECT Orders.CustomerID,
SUM(Discount*UnitPrice*Quantity) AS DiscountSpend,
SUM(UnitPrice*Quantity) AS UndiscountedRevenue,
SUM(Discount*UnitPrice*Quantity) / SUM(UnitPrice*Quantity) AS AvgDiscount
FROM Orders INNER JOIN OrderDetail
ON Orders.OrderID = OrderDetail.OrderID

GROUP BY CustomerID
ORDER BY DiscountSpend DESC

-- 4. Add a company name into 3 

SELECT CompanyName, Orders.CustomerID,
SUM(Discount*UnitPrice*Quantity) AS DiscountSpend,
SUM(UnitPrice*Quantity) AS UndiscountedRevenue,
SUM(Discount*UnitPrice*Quantity) / SUM(UnitPrice*Quantity) AS AvgDiscount
FROM Orders

INNER JOIN OrderDetail
ON Orders.OrderID = OrderDetail.OrderID

INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID

GROUP BY Orders.CustomerID
ORDER BY DiscountSpend DESC


-- 5. Understanding discontinued inventory 
-- Goal: Find what fraction of the inventory in each category has been discontinued.
--       If there is a category with a high fraction of discontinued products, then this is a problem to investigate. 

SELECT CategoryID,
UnitsInStock + UnitsOnOrder AS InventoryPosition,
UnitPrice * (UnitsInStock + UnitsOnOrder) AS InventoryPositionValue,
UnitPrice * (UnitsInStock + UnitsOnOrder) * Discontinued AS DiscontinuedInventoryPositionValue
FROM Products

SELECT CategoryID,
SUM(InventoryPositionValue) AS SumInventoryPositionValue,
SUM(DiscontinuedInventoryPositionValue) AS SumDiscontinuedInventoryPositionValue

FROM Q4a
GROUP BY CategoryID

SELECT CategoryID,
CASE 
    WHEN SumInventoryPositionValue < 0.01 THEN 
        CASE WHEN SumInventoryPositionValue = 0 THEN 0 
        ELSE SumDiscontinuedInventoryPositionValue / SumInventoryPositionValue 
        END
    ELSE SumDiscontinuedInventoryPositionValue / SumInventoryPositionValue
END AS FractionDiscontinuedValue
FROM Q4b;

