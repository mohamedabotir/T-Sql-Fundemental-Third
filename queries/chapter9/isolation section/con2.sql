use TSQL2012

----connection2 
--kill 54;
SELECT productid, unitprice
FROM Production.Products  WITH (READCOMMITTEDLOCK)
WHERE productid = 2;