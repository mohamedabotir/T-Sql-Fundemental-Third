use TSQL2012
----connection 1 
--set lock_timeout 5000;--if resource didn't release request will terminate
--set lock_timeout -1;
BEGIN TRAN;
 UPDATE Production.Products
 SET unitprice += 1.00
 WHERE productid = 2;