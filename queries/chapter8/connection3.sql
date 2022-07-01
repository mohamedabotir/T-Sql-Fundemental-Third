use TSQL2012;
SELECT productid, unitprice
FROM Production.Products  WITH (READCOMMITTEDLOCK)
WHERE productid = 2;