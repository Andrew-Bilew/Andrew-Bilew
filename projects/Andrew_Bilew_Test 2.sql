use petstore4;
-- 2,By value, which category of items were sold the most in the second quarter of the year?
SELECT m.Category, SUM(si.Quantity * si.SalePrice) AS TotalSales
FROM Sale s
JOIN SaleItem si ON s.SaleID = si.SaleID
JOIN merchandise m ON si.ItemID = m.ItemID
WHERE QUARTER(s.SaleDate) = 2
GROUP BY m.Category
ORDER BY TotalSales DESC
LIMIT 1;

-- 3, Which category of items had the highest sales value in May?
SELECT m.Category, SUM(si.Quantity * si.SalePrice) AS TotalSales
FROM Sale s
JOIN SaleItem si ON s.SaleID = si.SaleID
JOIN Merchandise m ON si.ItemID = m.ItemID
WHERE MONTH(s.SaleDate) = 5
GROUP BY m.Category
ORDER BY TotalSales DESC
LIMIT 1;

-- 4, From which supplier did the store purchase the most cat merchandise?

SELECT
    mo.SupplierID,
    s.Name AS SupplierName,
    COUNT(si.ItemID) AS CatMerchandiseCount
FROM
    SaleItem si
JOIN
    Merchandise m ON si.ItemID = m.ItemID
JOIN
    Sale sa ON si.SaleID = sa.SaleID
JOIN
    MerchandiseOrder mo ON sa.EmployeeID = mo.EmployeeID
JOIN
    Supplier s ON mo.SupplierID = s.SupplierID
WHERE
    m.Category = 'Cat'
GROUP BY
    mo.SupplierID, s.Name
ORDER BY
    CatMerchandiseCount DESC
LIMIT 1;


-- 5, Which sale had the highest total discount?  Discount on any item is 
-- -- the difference between ListPrice and SalePrice

SELECT
    s.SaleID,
    s.SaleDate,
    s.EmployeeID,
    s.CustomerID,
    SUM((s.SalesTax - si.SalePrice) * si.Quantity) AS TotalDiscount
FROM
    Sale s
JOIN
    SaleItem si ON s.SaleID = si.SaleID
GROUP BY
    s.SaleID, s.SaleDate, s.EmployeeID, s.CustomerID
ORDER BY
    TotalDiscount DESC
LIMIT 1;



-- 6, Which employee has been the top monthly seller the greatest number of times?
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(*) AS TopSellerCount
FROM
    Sale s
JOIN
    Employee e ON s.EmployeeID = e.EmployeeID
GROUP BY
    e.EmployeeID, e.FirstName, e.LastName
HAVING
    MAX(s.SalesTax) > 0
ORDER BY
    TopSellerCount DESC
LIMIT 1;


-- 7, What is the amount of money customers spent on cat products after they adopted a cat?
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(si.Quantity * si.SalePrice) AS TotalSpentOnCatProducts
FROM
    Customer c
JOIN
    Sale s ON c.CustomerID = s.CustomerID
JOIN
    SaleItem si ON s.SaleID = si.SaleID
JOIN
    Merchandise m ON si.ItemID = m.ItemID
WHERE
    m.Category = 'Cat'
GROUP BY
    c.CustomerID, c.FirstName, c.LastName;


-- 8, List customers who purchased Cat merchandise in January and March.
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM
    Customer c
JOIN
    Sale s ON c.CustomerID = s.CustomerID
JOIN
    SaleItem si ON s.SaleID = si.SaleID
JOIN
    Merchandise m ON si.ItemID = m.ItemID
WHERE
    m.Category = 'Cat'
AND
    MONTH(s.SaleDate) IN (1, 3)
GROUP BY
    c.CustomerID, c.FirstName, c.LastName
HAVING
    COUNT(DISTINCT MONTH(s.SaleDate)) = 2;

-- 9, List employees who ordered items from the same supplier in March and April
-- (could be different products).

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM
    Employee e
JOIN
    MerchandiseOrder mo ON e.EmployeeID = mo.EmployeeID
JOIN
    OrderItem oi ON mo.PONumber = oi.PONumber
JOIN
    Merchandise m ON oi.ItemID = m.ItemID
JOIN
    Supplier s ON mo.SupplierID = s.SupplierID
WHERE
    MONTH(mo.OrderDate) IN (3, 4)
GROUP BY
    e.EmployeeID, e.FirstName, e.LastName, s.SupplierID
HAVING
    COUNT(DISTINCT MONTH(mo.OrderDate)) = 2;
